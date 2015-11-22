class ContentFetcher
  attr_reader :mod_date, :date, :cohorts, :data

  def initialize(mod_date, date, cohorts = "", data = "")
    @mod_date      = mod_date
    @date          = date
    @cohorts       = cohorts
    @data          = data
  end

  def url
    "http://today.turing.io/outlines/"
  end

  def content
    if mod_date == ""
      @content ||= Nokogiri::HTML(open("#{url}#{date}"))
    elsif mod_date != ""
      @content ||= Nokogiri::HTML(open("#{url}#{mod_date}"))
    end
  end

  def elements
    content.text.gsub!("\n", "").split("  ").reject { |element| element == ''  }
  end

  def rooms
    cohorts.each do |cohort|
      data[cohort] = []
    end
  end

  def link_up
    cohorts.each_with_index do |cohort, cohort_index|
      element_index = elements.index(cohort)
      element       = cohort
      next_cohort   = cohorts[cohort_index + 1] || '©'

      until element.include?(next_cohort)
        element = elements[element_index]
        data[cohort] << element
        element_index += 1
      end
    end
  end
end
