class FetchInsightsWorker
  include Sidekiq::Worker

  def perform(campaign_id)
    campaign = Campaign.find(campaign_id)

    unless campaign.external_id.present?
      Rails.logger.error "Campaign #{campaign_id} has no external_id. Cannot fetch insights."
      return
    end

    service = Integrations::MetaService.new
    response = service.fetch_campaign_insights(campaign)

    unless response.success?
      Rails.logger.error "Failed to fetch insights for campaign #{campaign_id}: HTTP #{response.code} - #{response.body}"
      return
    end

    data = JSON.parse(response.body)

    # Handle different response formats
    insights_data = data.is_a?(Array) ? data.first : data

    campaign.insights.create!(
      impressions: insights_data["impressions"] || insights_data[:impressions] || 0,
      clicks: insights_data["clicks"] || insights_data[:clicks] || 0,
      spend: insights_data["spend"] || insights_data[:spend] || 0.0,
      conversions: insights_data["conversions"] || insights_data[:conversions] || 0
    )

    Rails.logger.info "Successfully fetched insights for campaign #{campaign_id}"
  rescue JSON::ParserError => e
    Rails.logger.error "Failed to parse insights response for campaign #{campaign_id}: #{e.message}"
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error "Failed to save insights for campaign #{campaign_id}: #{e.message}"
  rescue => e
    Rails.logger.error "Fetch insights error for campaign #{campaign_id}: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    raise e
  end
end
  