class Campaign < ApplicationRecord
  has_many :insights, dependent: :destroy
  has_many :campaign_audiences, dependent: :destroy
  has_many :audiences, through: :campaign_audiences
  has_many :attributions, dependent: :destroy

  enum :channel, { meta: "meta", google: "google", linkedin: "linkedin" }
  enum :status, { draft: "draft", synced: "synced", active: "active", completed: "completed" }, default: :draft

  validates :name, presence: true
  
  before_validation :set_default_status, on: :create
  
  scope :with_insights, -> { joins(:insights).distinct }
  scope :without_insights, -> { left_joins(:insights).where(insights: { id: nil }) }
  scope :search, ->(query) {
    return all if query.blank?
    where("name LIKE ? OR objective LIKE ? OR external_id LIKE ?", "%#{query}%", "%#{query}%", "%#{query}%")
  }
  scope :by_channel, ->(channel) { where(channel: channel) if channel.present? }
  scope :by_status, ->(status) { where(status: status) if status.present? }
  scope :active_campaigns, -> { where(status: :active).where.not(external_id: nil) }
  scope :recent, -> { order(created_at: :desc) }
  
  def total_spend
    insights.sum(:spend) || 0.0
  end
  
  def budget_reached?
    budget.present? && total_spend >= budget
  end
  
  def latest_insight
    insights.order(created_at: :desc).first
  end
  
  def ctr
    return 0.0 if latest_insight.nil? || latest_insight.impressions.zero?
    (latest_insight.clicks.to_f / latest_insight.impressions * 100).round(2)
  end
  
  def cpc
    return 0.0 if latest_insight.nil? || latest_insight.clicks.zero?
    (latest_insight.spend / latest_insight.clicks).round(2)
  end
  
  def recent_attributions(limit = 10)
    attributions.order(timestamp: :desc).limit(limit)
  end
  
  private
  
  def set_default_status
    self.status = :draft if status.blank?
  end
end
