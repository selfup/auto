COHORTS = %w(1505 1507 1508 1510)

Nokogiri::HTML(open('http://today.turing.io/outlines/2015-11-09'))
elements = content.text.gsub!("\n", "").split("  ")
elements = elements.reject { |element| element == ''  }

@classrooms = {}

COHORTS.each do |cohort|
  @classrooms[cohort] = []
end

def
COHORTS.each_with_index do |cohort, cohort_index|
  element_index = elements.index(cohort)
  element       = cohort
  next_cohort   = COHORTS[cohort_index + 1] || '©'

  until element.include?(next_cohort)
    element = elements[element_index]
    @classrooms[cohort] << element
    element_index += 1
  end
end
