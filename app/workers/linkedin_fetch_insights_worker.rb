class LinkedinFetchInsightsWorker
  include Sidekiq::Worker

  def perform(campaign_id)
    campaign = Campaign.find(campaign_id)

    unless campaign.external_id.present?
      Rails.logger.error "Campaign #{campaign_id} has no external_id. Cannot fetch LinkedIn insights."
      return
    end

    service = Integrations::LinkedInService.new
    response = service.fetch_campaign_insights(campaign)

    unless response.success?
      Rails.logger.error "Failed to fetch LinkedIn insights for campaign #{campaign_id}: HTTP #{response.code} - #{response.body}"
      return
    end

    data = JSON.parse(response.body)

    # Handle different response formats
    insights_data = data.is_a?(Array) ? data.first : data

    insight = campaign.insights.create!(
      impressions: insights_data["impressions"] || insights_data[:impressions] || 0,
      clicks: insights_data["clicks"] || insights_data[:clicks] || 0,
      spend: insights_data["spend"] || insights_data[:spend] || 0.0,
      conversions: insights_data["conversions"] || insights_data[:conversions] || 0
    )

    # Update campaign status to active after first insight
    if campaign.synced? || campaign.draft?
      campaign.update!(status: :active)
    end

    # Check if budget reached
    if campaign.budget_reached?
      campaign.update!(status: :completed)
    end

    # Create attributions (randomly pick 1-3 contacts from campaign audiences)
    create_attributions(campaign, insight.clicks)

    Rails.logger.info "Successfully fetched LinkedIn insights for campaign #{campaign_id}"
  rescue JSON::ParserError => e
    Rails.logger.error "Failed to parse LinkedIn insights response for campaign #{campaign_id}: #{e.message}"
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error "Failed to save LinkedIn insights for campaign #{campaign_id}: #{e.message}"
  rescue => e
    Rails.logger.error "Fetch LinkedIn insights error for campaign #{campaign_id}: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    raise e
  end

  private

  def create_attributions(campaign, click_count)
    # Get all contacts from campaign's audiences
    contact_ids = campaign.audiences.joins(:contacts).pluck("contacts.id").uniq

    return if contact_ids.empty?

    # Randomly pick 1-3 contacts
    num_contacts = [1, 2, 3].sample
    selected_contact_ids = contact_ids.sample([num_contacts, contact_ids.length].min)

    # Create click attributions with random timestamps (within last 24 hours)
    selected_contact_ids.each do |contact_id|
      random_time = rand(24.hours).ago
      campaign.attributions.create!(
        contact_id: contact_id,
        event_type: "click",
        timestamp: random_time
      )
    end

    Rails.logger.info "Created #{selected_contact_ids.length} attribution(s) for campaign #{campaign.id}"
  end
end

