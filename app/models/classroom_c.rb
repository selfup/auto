class ClassroomC < ActiveRecord::Base

  def self.initialize_vars
    @mod1           = ["N/A"]
    @mod2           = ["N/A"]
    @mod3           = ["N/A"]
    @mod4           = ["N/A"]
    @teacher        = ["Unknown"]
    @classroom_data = {}
  end

  COHORTS  = %w(1505 1507 1508 1510)
  TEACHERS = %w(Jeff Josh Rachel Jorge Steve Horace Andrew Mike Tess)

  def self.date
    if Time.now.asctime.split[0] == "Sat"
      Time.at(Time.now.to_i - 86400).to_s.split[0]
    elsif Time.now.asctime.split[0] == "Sun"
      Time.at(Time.now.to_i - 172800).to_s.split[0]
    else
      Time.now.to_s.split(" ")[0]
    end
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
      if find.include?("Classroom C")
        @mod1.unshift(find)
      end
    end
  end

  def self.module_2
    @classroom_data[COHORTS[2]].map.with_index do |find, index|
      if find.include?("Classroom C")
        @mod2.unshift(find)
      end
    end
  end

  def self.module_3
    @classroom_data[COHORTS[1]].map.with_index do |find, index|
      if find.include?("Classroom C")
        @mod3.unshift(find)
      end
    end
  end

  def self.module_4
    @classroom_data[COHORTS[0]].map.with_index do |find, index|
      if find.include?("Classroom C")
        @mod4.unshift(find)
      end
    end
  end

  def self.check_for_conflicts(conflicts)
    conflicts = conflicts.reject { |element| element == 'No'  }
    if conflicts.length >= 2
      "Conflict!"
    else
      "Good to Go"
    end
  end

  def self.conflict?
    link_the_cohort_data
    module_1; module_2; module_3; module_4
    modules = [@mod1[0], @mod2[0], @mod3[0], @mod4[0]]
    conflicts = []
    modules.map do |conflict|
      if conflict.include?("Classroom C")
        conflicts << "Yes"
      else
        conflicts << "No"
      end
    end
    check_for_conflicts(conflicts)
  end

  def self.find_b
    link_the_cohort_data
    module_1; module_2; module_3; module_4
    if @mod1[0].include?("Classroom C")
      cohort(COHORTS[3])
    elsif @mod2[0].include?("Classroom C")
      cohort(COHORTS[2])
    elsif @mod3[0].include?("Classroom C")
      cohort(COHORTS[1])
    elsif @mod4[0].include?("Classroom C")
      cohort(COHORTS[0])
    else
      tbd
    end
  end

  def self.find_teacher
    TEACHERS.map do |teacher|
      if @mod1[0].include?(teacher)
        @teacher.unshift(teacher)
      elsif @mod2[0].include?(teacher)
        @teacher.unshift(teacher)
      elsif @mod3[0].include?(teacher)
        @teacher.unshift(teacher)
      elsif @mod4[0].include?(teacher)
        @teacher.unshift(teacher)
      end
    end
  end

  def self.cohort(cohort_num)
    find_teacher
    ClassroomC.first.update(
                              cohort: cohort_num.ljust(14, " "),
                              teacher: @teacher[0].ljust(14, " ")
                            )
  end

  def self.tbd
    check_today = "Check Today!"
    i_dunno     = "I Dunno :P"
    ClassroomC.first.update(
                              cohort: check_today.ljust(14, " "),
                              teacher: i_dunno.ljust(14, " ")
                            )
  end

  def self.conflicting_cohorts
    conflict_message = "Conflict"
    help_message     = "Help"
    ClassroomA.first.update(
                              cohort: conflict_message.ljust(14, " "),
                              teacher: help_message.ljust(14, " ")
                            )
  end

  def self.update_info
    if conflict? == "Conflict!"
      conflicting_cohorts
    else
      find_b
    end
  end

end
