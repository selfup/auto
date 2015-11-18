class Parser
  attr_reader :location, :endpoint_model, :modified_date,
              :classroom_data, :date, :day_time, :weekend

  def initialize(location, endpoint_model, modified_date = "")
    @location       = location
    @endpoint_model = endpoint_model
    @teacher        = ["Unknown"]
    @classroom_data ||= {}
    @modified_date  = modified_date
    @day_time       = DayTracker.new.day_time
    @date           = DayTracker.new.date
    @weekend        = DayTracker.new(weekend!).weekend
  end

  COHORTS  = %w(1505 1507 1508 1510)
  TEACHERS = %w(Jeff Josh Rachel Jorge Steve Horace Andrew Mike Tess)

  def content
    if modified_date == ""
      @content ||= Nokogiri::HTML(open("http://today.turing.io/outlines/#{date}"))
    elsif modified_date != ""
      @content ||= Nokogiri::HTML(open("http://today.turing.io/outlines/#{modified_date}"))
    end
  end

  def elements
    doc = content.text
    data = doc.gsub!("\n", "").split("  ")
    data.reject { |element| element == ''  }
  end

  def classrooms
    elements
    COHORTS.each do |cohort|
      classroom_data[cohort] = []
    end
  end

  def link_the_cohort_data
    classrooms
    COHORTS.each_with_index do |cohort, cohort_index|
      element_index = elements.index(cohort)
      element       = cohort
      next_cohort   = COHORTS[cohort_index + 1] || '©'

      until element.include?(next_cohort)
        element = elements[element_index]
        classroom_data[cohort] << element
        element_index += 1
      end
    end
  end

  def module_1
    classroom_data[COHORTS[3]][2]
  end

  def module_2
    classroom_data[COHORTS[2]][2]
  end

  def module_3
    classroom_data[COHORTS[1]][2]
  end

  def module_4
    classroom_data[COHORTS[0]][2]
  end

  def check_for_conflicts(conflicts)
    conflicts = conflicts.reject { |element| element == 'No'  }
    if conflicts.length >= 2
      "Conflict!"
    else
      "Good to Go"
    end
  end

  def conflict?
    modules = [module_1, module_2, module_3, module_4]
    conflicts = []
    modules.map do |conflict|
      if conflict.include?(@location)
        conflicts << "Yes"
      else
        conflicts << "No"
      end
    end
    check_for_conflicts(conflicts)
  end

  def find_cohort
    if module_1.include?(@location)
      find_teacher(module_1); cohort(COHORTS[3])
    elsif module_2.include?(@location)
      find_teacher(module_2); cohort(COHORTS[2])
    elsif module_3.include?(@location)
      find_teacher(module_3); cohort(COHORTS[1])
    elsif module_4.include?(@location)
      find_teacher(module_4); cohort(COHORTS[0])
    else
      DbParseUpdater.new(endpoint_model).tbd
    end
  end

  def find_teacher(mod_teacher)
    mod_teacher.split(" ").map do |find|
      if TEACHERS.include?(find)
        return @teacher.unshift(find)
      end
    end
  end

  def cohort(cohort_num)
    weekend
    DbParseUpdater.new(endpoint_model).cohort(cohort_num, @teacher)
  end

  def weekend!
    DbParseUpdater.new(endpoint_model).weekend!
  end

  def update_info
    link_the_cohort_data
    if weekend
      weekend!
    elsif conflict? == "Conflict!"
      DbParseUpdater.new(endpoint_model).conflicting_cohorts
    else
      find_cohort
    end
  end
end
