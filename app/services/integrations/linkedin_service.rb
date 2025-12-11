module Integrations
  class LinkedInService
    include HTTParty
    base_uri "https://mockapi.io/api/v1/linkedin"

    def initialize(api_key: ENV["LINKEDIN_API_KEY"])
      @headers = {
        "Authorization" => "Bearer #{api_key}",
        "Content-Type" => "application/json"
      }
    end

    def create_matched_audience(audience)
      body = {
        name: audience.name,
        description: audience.description || "",
        contacts: audience.contacts.map(&:email)
      }

      self.class.post("/matched_audiences", headers: @headers, body: body.to_json)
    end

    def fetch_campaign_insights(campaign)
      raise ArgumentError, "Campaign must have an external_id" unless campaign.external_id.present?

      self.class.get(
        "/campaigns/#{campaign.external_id}/insights",
        headers: @headers,
        timeout: 30
      )
    rescue HTTParty::Error => e
      Rails.logger.error "HTTP error fetching LinkedIn insights: #{e.message}"
      raise
    end
  end
end
