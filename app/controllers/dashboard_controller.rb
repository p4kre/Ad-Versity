class DashboardController < ApplicationController
  def index
    # Overall stats
    @total_campaigns = Campaign.count
    @total_audiences = Audience.count
    @total_contacts = Contact.count
    
    # Campaign stats
    @campaigns_with_insights = Campaign.with_insights.count
    @campaigns_by_channel = Campaign.group(:channel).count
    @total_budget = Campaign.sum(:budget) || 0
    
    # Audience stats
    @audiences_by_status = Audience.group(:status).count
    @total_audience_contacts = Contact.joins(:audiences).distinct.count
    
    # Recent activity
    @recent_campaigns = Campaign.recent.limit(5)
    @recent_audiences = Audience.order(created_at: :desc).limit(5)
    
    # Performance metrics
    @total_insights = Insight.count
    @total_impressions = Insight.sum(:impressions) || 0
    @total_clicks = Insight.sum(:clicks) || 0
    @total_spend = Insight.sum(:spend) || 0
    @total_conversions = Insight.sum(:conversions) || 0
    
    # Calculate CTR and conversion rate
    @ctr = @total_impressions > 0 ? (@total_clicks.to_f / @total_impressions * 100) : 0
    @conversion_rate = @total_clicks > 0 ? (@total_conversions.to_f / @total_clicks * 100) : 0
    @cpc = @total_clicks > 0 ? (@total_spend.to_f / @total_clicks) : 0
    
    # Top performing campaigns - using a more SQLite-compatible approach
    @top_campaigns = Campaign.joins(:insights)
                             .select("campaigns.id, campaigns.name, campaigns.channel, campaigns.objective, campaigns.budget, campaigns.external_id, campaigns.created_at, campaigns.updated_at")
                             .select("SUM(insights.impressions) as total_impressions")
                             .select("SUM(insights.clicks) as total_clicks")
                             .select("SUM(insights.conversions) as total_conversions")
                             .select("SUM(insights.spend) as total_spend")
                             .group("campaigns.id")
                             .order("SUM(insights.impressions) DESC")
                             .limit(5)
                             .to_a
  end
end
