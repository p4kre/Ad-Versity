module DemographicMatcher
  class Service
    def initialize(audience)
      @audience = audience
    end

    def suggest_contacts(limit: 10)
      return [] if @audience.contacts.empty?

      # Analyze demographics of existing contacts in audience
      demographics = analyze_audience_demographics

      # Find contacts matching the most common demographics
      suggestions = Contact.match_demographics(demographics)
                          .where.not(id: @audience.contact_ids)
                          .limit(limit)

      suggestions
    end

    def analyze_audience_demographics
      contacts = @audience.contacts
      return {} if contacts.empty?

      demographics = {}

      # Find most common age range
      age_ranges = contacts.where.not(age_range: [nil, '']).group(:age_range).count
      demographics[:age_range] = age_ranges.max_by { |_, count| count }&.first if age_ranges.any?

      # Find most common gender
      genders = contacts.where.not(gender: [nil, '']).group(:gender).count
      demographics[:gender] = genders.max_by { |_, count| count }&.first if genders.any?

      # Find most common income range
      income_ranges = contacts.where.not(income_range: [nil, '']).group(:income_range).count
      demographics[:income_range] = income_ranges.max_by { |_, count| count }&.first if income_ranges.any?

      # Find most common education level
      education_levels = contacts.where.not(education_level: [nil, '']).group(:education_level).count
      demographics[:education_level] = education_levels.max_by { |_, count| count }&.first if education_levels.any?

      # Find most common occupation (partial match)
      occupations = contacts.where.not(occupation: [nil, '']).pluck(:occupation).compact
      if occupations.any?
        # Find common keywords in occupations
        common_keywords = find_common_keywords(occupations)
        demographics[:occupation] = common_keywords.first if common_keywords.any?
      end

      # Find most common marital status
      marital_statuses = contacts.where.not(marital_status: [nil, '']).group(:marital_status).count
      demographics[:marital_status] = marital_statuses.max_by { |_, count| count }&.first if marital_statuses.any?

      # Find most common family status
      family_statuses = contacts.where.not(family_status: [nil, '']).group(:family_status).count
      demographics[:family_status] = family_statuses.max_by { |_, count| count }&.first if family_statuses.any?

      demographics
    end

    private

    def find_common_keywords(occupations)
      # Split occupations into words and find most common
      words = occupations.flat_map { |occ| occ.downcase.split(/\s+/) }
      word_counts = words.group_by(&:itself).transform_values(&:count)
      # Return words that appear in at least 30% of occupations
      threshold = (occupations.length * 0.3).ceil
      word_counts.select { |_, count| count >= threshold }.keys.first(3)
    end
  end
end

