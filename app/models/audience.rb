class Audience < ApplicationRecord
  has_many :audience_contacts, dependent: :destroy
  has_many :contacts, through: :audience_contacts
  has_many :campaign_audiences, dependent: :destroy
  has_many :campaigns, through: :campaign_audiences

  enum :status, { draft: "draft", syncing: "syncing", synced: "synced", failed: "failed" }

  validates :name, presence: true

  before_validation :set_default_status, on: :create
  after_initialize :ensure_status_present

  def status
    super || "draft"
  end

  private

  def set_default_status
    self.status = :draft if status.blank?
  end

  def ensure_status_present
    self.status = :draft if status.blank?
  end

  scope :search, ->(query) {
    return all if query.blank?
    where("name LIKE ? OR description LIKE ?", "%#{query}%", "%#{query}%")
  }
  scope :by_status, ->(status) { where(status: status) if status.present? }
  scope :with_contacts, -> { joins(:contacts).distinct }
  scope :without_contacts, -> { left_joins(:contacts).where(contacts: { id: nil }) }
end
