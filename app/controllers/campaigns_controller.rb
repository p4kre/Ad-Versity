class CampaignsController < ApplicationController
  before_action :set_campaign, only: [:show, :edit, :update, :destroy, :fetch_insights, :fetch_linkedin_insights]

  def index
    @campaigns = Campaign.all
    @campaigns = @campaigns.search(params[:search]) if params[:search].present?
    @campaigns = @campaigns.by_channel(params[:channel]) if params[:channel].present?
    @campaigns = @campaigns.recent
  end

  def show; end

  def new
    @campaign = Campaign.new
    @audiences = Audience.all.order(:name)
  end

  def create
    @campaign = Campaign.new(campaign_params)
    if @campaign.save
      redirect_to @campaign, notice: "Campaign created"
    else
      render :new
    end
  end

  def edit
    @audiences = Audience.all.order(:name)
  end

  def update
    if @campaign.update(campaign_params)
      redirect_to @campaign, notice: "Campaign updated"
    else
      render :edit
    end
  end

  def destroy
    campaign_name = @campaign.name
    @campaign.destroy
    redirect_to campaigns_path, notice: "Campaign '#{campaign_name}' has been deleted successfully."
  rescue => e
    redirect_to campaigns_path, alert: "Failed to delete campaign: #{e.message}"
  end

  def fetch_insights
    unless @campaign.external_id.present?
      redirect_to @campaign, alert: "Campaign must have an External ID to fetch insights."
      return
    end

    FetchInsightsWorker.perform_async(@campaign.id)
    redirect_to @campaign, notice: "Insights fetch started. This may take a few moments."
  end

  def fetch_linkedin_insights
    LinkedinFetchInsightsWorker.perform_async(@campaign.id)
    redirect_to @campaign, notice: "Fetching LinkedIn insights"
  end

  private

  def set_campaign
    @campaign = Campaign.find(params[:id])
  end

  def campaign_params
    params.require(:campaign).permit(:name, :objective, :budget, :channel, :external_id, audience_ids: [])
  end
end
