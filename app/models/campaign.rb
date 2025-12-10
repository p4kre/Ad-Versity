class Campaign < ApplicationRecord
  has_many :insights, dependent: :destroy
  has_many :campaign_audiences, dependent: :destroy
  has_many :audiences, through: :campaign_audiences

  enum :channel, { meta: "meta", google: "google", linkedin: "linkedin" }

  validates :name, presence: true
  
  scope :with_insights, -> { joins(:insights).distinct }
  scope :without_insights, -> { left_joins(:insights).where(insights: { id: nil }) }
  scope :search, ->(query) {
    return all if query.blank?
    where("name LIKE ? OR objective LIKE ? OR external_id LIKE ?", "%#{query}%", "%#{query}%", "%#{query}%")
  }
  scope :by_channel, ->(channel) { where(channel: channel) if channel.present? }
  scope :recent, -> { order(created_at: :desc) }
end
