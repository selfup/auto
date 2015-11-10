class ClassroomB < ActiveRecord::Base

  def self.initialize_vars
    @mod1 = ["N/A"]
    @mod2 = ["N/A"]
    @mod3 = ["N/A"]
    @mod4 = ["N/A"]
    @classroom_data = {}
  end

  COHORTS = %w(1505 1507 1508 1510)

  def self.date
    Time.now.to_s.split(" ")[0]
  end

  def self.content
    @content ||= Nokogiri::HTML(open("http://today.turing.io/outlines/#{date}"))
  end

  def self.elements
    data = content.text.gsub!("\n", "").split("  ")
    data.reject { |element| element == ''  }
  end

  def self.classrooms
    initialize_vars
    elements
    COHORTS.each do |cohort|
      @classroom_data[cohort] = []
    end
  end

  def self.link_the_cohort_data
    classrooms
    COHORTS.each_with_index do |cohort, cohort_index|
      element_index = elements.index(cohort)
      element       = cohort
      next_cohort   = COHORTS[cohort_index + 1] || '©'

      until element.include?(next_cohort)
        element = elements[element_index]
        @classroom_data[cohort] << element
        element_index += 1
      end
    end
  end

  def self.module_1
    @classroom_data[COHORTS[3]].map.with_index do |find, index|
      if find.include?("Classroom A")
        @mod1.unshift(find)
      end
    end
  end

  def self.module_2
    @classroom_data[COHORTS[2]].map.with_index do |find, index|
      if find.include?("Classroom A")
        @mod2.unshift(find)
      end
    end
  end

  def self.module_3
    @classroom_data[COHORTS[1]].map.with_index do |find, index|
      if find.include?("Classroom A")
        @mod3.unshift(find)
      end
    end
  end

  def self.module_4
    @classroom_data[COHORTS[0]].map.with_index do |find, index|
      if find.include?("Classroom A")
        @mod4.unshift(find)
      end
    end
  end

  def self.find_b
    link_the_cohort_data
    module_1; module_2; module_3; module_4
    if @mod1[0].include?("Classroom A")
      cohort(COHORTS[3])
    elsif @mod2[0].include?("Classroom A")
      cohort(COHORTS[2])
    elsif @mod3[0].include?("Classroom A")
      cohort(COHORTS[1])
    elsif @mod4[0].include?("Classroom A")
      cohort(COHORTS[0])
    else
      tbd
    end
  end

  def self.cohort(cohort_num)
    ClassroomB.first.update(cohort: cohort_num.ljust(14, " "), teacher: "9:00 AM")
  end

  def self.tbd
    ClassroomB.first.update(cohort: "TBD      ", teacher: "TBD      ")
  end

  def self.update_info
    find_b
  end

end
