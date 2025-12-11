class Attribution < ApplicationRecord
  belongs_to :contact
  belongs_to :campaign

  validates :event_type, presence: true, inclusion: { in: %w[click impression] }
  validates :timestamp, presence: true

  scope :clicks, -> { where(event_type: "click") }
  scope :impressions, -> { where(event_type: "impression") }
  scope :recent, -> { order(timestamp: :desc) }
end
