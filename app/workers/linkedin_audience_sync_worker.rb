class LinkedinAudienceSyncWorker
  include Sidekiq::Worker

  def perform(audience_id)
    audience = Audience.find(audience_id)
    service = Integrations::LinkedInService.new

    response = service.create_matched_audience(audience)

    if response.code == 200
      audience.update(status: :synced)
    else
      audience.update(status: :failed)
      Rails.logger.error "LinkedIn audience sync failed: #{response.body}"
    end
  rescue => e
    audience.update(status: :failed) if audience
    Rails.logger.error "LinkedIn audience sync error: #{e.message}"
    raise e
  end
end
