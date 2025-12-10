class AudienceSyncWorker
    include Sidekiq::Worker
  
    def perform(audience_id)
      audience = Audience.find(audience_id)
      service = Integrations::MetaService.new
  
      response = service.create_custom_audience(audience)
  
      if response.code == 200
        audience.update(status: :synced)
      else
        audience.update(status: :failed)
        Rails.logger.error "Audience sync failed: #{response.body}"
      end
    rescue => e
      audience.update(status: :failed) if audience
      Rails.logger.error "Audience sync error: #{e.message}"
      raise e
    end
  end
  