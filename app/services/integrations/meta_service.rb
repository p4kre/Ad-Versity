module Integrations
    class MetaService
      include HTTParty
      base_uri "https://api.mockadsplatform.com" # swap with real or mock URL
  
      def initialize(api_key: ENV["META_API_KEY"])
        @headers = {
          "Authorization" => "Bearer #{api_key}",
          "Content-Type" => "application/json"
        }
      end
  
      def create_custom_audience(audience)
        body = {
          name: audience.name,
          description: audience.description,
          contacts: audience.contacts.map { |c| { email: c.email, name: "#{c.first_name} #{c.last_name}" } }
        }
  
        self.class.post("/custom_audiences", headers: @headers, body: body.to_json)
      end
  
      def fetch_campaign_insights(campaign)
        raise ArgumentError, "Campaign must have an external_id" unless campaign.external_id.present?
        
        self.class.get(
          "/campaigns/#{campaign.external_id}/insights",
          headers: @headers,
          timeout: 30
        )
      rescue HTTParty::Error => e
        Rails.logger.error "HTTP error fetching insights: #{e.message}"
        raise
      end
    end
  end
  