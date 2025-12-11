class LinkedinCampaignPushWorker
  include Sidekiq::Worker

  def perform(campaign_id)
    campaign = Campaign.find(campaign_id)
    service = Integrations::LinkedInService.new

    response = service.push_campaign(campaign)

    if response.success?
      data = JSON.parse(response.body)
      external_id = data["external_id"] || data[:external_id]

      if external_id.present?
        campaign.update!(
          external_id: external_id,
          status: :synced
        )
        Rails.logger.info "Successfully pushed campaign #{campaign_id} to LinkedIn. External ID: #{external_id}"
      else
        Rails.logger.error "LinkedIn API response missing external_id for campaign #{campaign_id}"
        raise "Missing external_id in API response"
      end
    else
      Rails.logger.error "Failed to push campaign #{campaign_id} to LinkedIn: HTTP #{response.code} - #{response.body}"
      raise "LinkedIn API error: #{response.code}"
    end
  rescue JSON::ParserError => e
    Rails.logger.error "Failed to parse LinkedIn push response for campaign #{campaign_id}: #{e.message}"
    raise
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error "Failed to update campaign #{campaign_id}: #{e.message}"
    raise
  rescue => e
    Rails.logger.error "Push campaign error for campaign #{campaign_id}: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    raise e
  end
end
