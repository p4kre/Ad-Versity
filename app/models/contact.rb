class Contact < ApplicationRecord
  has_many :audience_contacts, dependent: :destroy
  has_many :audiences, through: :audience_contacts
  has_many :attributions, dependent: :destroy

  scope :search, ->(query) {
    return all if query.blank?
    where(
      "first_name LIKE ? OR last_name LIKE ? OR email LIKE ? OR company LIKE ? OR job_title LIKE ?",
      "%#{query}%", "%#{query}%", "%#{query}%", "%#{query}%", "%#{query}%"
    )
  }

  scope :by_company, ->(company) { where("company LIKE ?", "%#{company}%") if company.present? }
  
  # Demographic scopes
  scope :by_age_range, ->(age_range) { where(age_range: age_range) if age_range.present? }
  scope :by_gender, ->(gender) { where(gender: gender) if gender.present? }
  scope :by_income_range, ->(income_range) { where(income_range: income_range) if income_range.present? }
  scope :by_education_level, ->(education_level) { where(education_level: education_level) if education_level.present? }
  scope :by_occupation, ->(occupation) { where("occupation LIKE ?", "%#{occupation}%") if occupation.present? }
  scope :by_marital_status, ->(marital_status) { where(marital_status: marital_status) if marital_status.present? }
  scope :by_family_status, ->(family_status) { where(family_status: family_status) if family_status.present? }
  
  # Match contacts based on demographics
  def self.match_demographics(criteria = {})
    contacts = all
    contacts = contacts.by_age_range(criteria[:age_range]) if criteria[:age_range].present?
    contacts = contacts.by_gender(criteria[:gender]) if criteria[:gender].present?
    contacts = contacts.by_income_range(criteria[:income_range]) if criteria[:income_range].present?
    contacts = contacts.by_education_level(criteria[:education_level]) if criteria[:education_level].present?
    contacts = contacts.by_occupation(criteria[:occupation]) if criteria[:occupation].present?
    contacts = contacts.by_marital_status(criteria[:marital_status]) if criteria[:marital_status].present?
    contacts = contacts.by_family_status(criteria[:family_status]) if criteria[:family_status].present?
    contacts
  end
end
