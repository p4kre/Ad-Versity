class LinkedinInsightsBatchWorker
  include Sidekiq::Worker

  def perform
    campaigns = Campaign.active_campaigns

    Rails.logger.info "Starting LinkedIn insights batch sync for #{campaigns.count} campaign(s)"

    campaigns.find_each do |campaign|
      LinkedinFetchInsightsWorker.perform_async(campaign.id)
    end

    Rails.logger.info "Enqueued #{campaigns.count} LinkedIn insights fetch job(s)"
  rescue => e
    Rails.logger.error "LinkedIn insights batch sync error: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    raise e
  end
end
