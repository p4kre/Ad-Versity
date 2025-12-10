module ApplicationHelper
  def nav_class(path)
    'active' if request.path == path || (path == root_path && request.path == '/')
  end

  def format_demographic_value(value)
    return '-' if value.blank?
    value.humanize.gsub('_', ' ')
  end

  def format_income_range(value)
    return '-' if value.blank?
    case value
    when 'under_25k'
      'Under $25,000'
    when '25k_49k'
      '$25,000 - $49,999'
    when '50k_74k'
      '$50,000 - $74,999'
    when '75k_99k'
      '$75,000 - $99,999'
    when '100k_149k'
      '$100,000 - $149,999'
    when '150k_plus'
      '$150,000+'
    else
      value.humanize.gsub('_', ' ')
    end
  end
end
