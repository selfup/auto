class Parser
  attr_reader :location, :endpoint_model, :modified_date

  def initialize(location, endpoint_model, modified_date = "")
    @location       = location
    @endpoint_model = endpoint_model
    @mod1           = ["N/A"]
    @mod2           = ["N/A"]
    @mod3           = ["N/A"]
    @mod4           = ["N/A"]
    @teacher        = ["Unknown"]
    @classroom_data = {}
    @modified_date  = modified_date
  end

  COHORTS  = %w(1505 1507 1508 1510)
  TEACHERS = %w(Jeff Josh Rachel Jorge Steve Horace Andrew Mike Tess)

  def day_time
    Time.now.asctime.split[0]
  end

  def date
    if day_time == "Sat"
      Time.at(Time.now.to_i - 86400).to_s.split[0]
    elsif day_time == "Sun"
      Time.at(Time.now.to_i - 172800).to_s.split[0]
    else
      Time.now.to_s.split(" ")[0]
    end
  end

  def weekend?
    if day_time == "Fri" || day_time == "Sat" || day_time == "Sun"
      weekend!
    end
  end

  def content
    if @modified_date == ""
      @content ||= Nokogiri::HTML(open("http://today.turing.io/outlines/#{date}"))
    elsif @modified_date != ""
      @content ||= Nokogiri::HTML(open("http://today.turing.io/outlines/#{@modified_date}"))
    end
  end

  def elements
    doc = content.text
    if doc.include?("Generator Script")
      until doc.include?("Generator Script") != true
        sleep(5)
        puts "**fetching again**"
        content
      end
    end
    data = doc.gsub!("\n", "").split("  ")
    data.reject { |element| element == ''  }
  end

  def classrooms
    elements
    COHORTS.each do |cohort|
      @classroom_data[cohort] = []
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
        @classroom_data[cohort] << element
        element_index += 1
      end
    end
  end

  def module_1
    @mod1.unshift(@classroom_data[COHORTS[3]][2])
  end

  def module_2
    @mod2.unshift(@classroom_data[COHORTS[2]][2])
  end

  def module_3
    @mod3.unshift(@classroom_data[COHORTS[1]][2])
  end

  def module_4
    @mod4.unshift(@classroom_data[COHORTS[0]][2])
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
    link_the_cohort_data
    module_1; module_2; module_3; module_4
    modules = [@mod1[0], @mod2[0], @mod3[0], @mod4[0]]
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
    link_the_cohort_data
    module_1; module_2; module_3; module_4
    if @mod1[0].include?(@location)
      find_teacher(@mod1[0]); cohort(COHORTS[3])
    elsif @mod2[0].include?(@location)
      find_teacher(@mod2[0]); cohort(COHORTS[2])
    elsif @mod3[0].include?(@location)
      find_teacher(@mod3[0]); cohort(COHORTS[1])
    elsif @mod4[0].include?(@location)
      find_teacher(@mod4[0]); cohort(COHORTS[0])
    else
      tbd
    end
  end

  def find_teacher(mod_teacher)
    TEACHERS.map do |teacher|
      if mod_teacher.include?(teacher)
        @teacher.unshift(teacher)
      end
    end
  end

  def cohort(cohort_num)
    weekend?
    endpoint_model.first.update(
                                cohort: cohort_num.ljust(14, " "),
                                teacher: @teacher[0].ljust(14, " ")
                               )
    @teacher = ["Unknown"]
  end

  def tbd
    check_today = "Check Today!"
    i_dunno     = "I Dunno :P"
    endpoint_model.first.update(
                                cohort: check_today.ljust(14, " "),
                                teacher: i_dunno.ljust(14, " ")
                              )
  end

  def conflicting_cohorts
    conflict_message = "Conflict"
    help_message = "Help"
    endpoint_model.first.update(
                                cohort: conflict_message.ljust(14, " "),
                                teacher: help_message.ljust(14, " ")
                              )
  end

  def weekend!
    friday_message = "Weekend!!!"
    weekend_message = "Check Today :D"
    endpoint_model.first.update(
                                cohort: friday_message.ljust(14, " "),
                                teacher: weekend_message.ljust(14, " ")
                              )
  end

  def update_info
    if conflict? == "Conflict!"
      conflicting_cohorts
    else
      find_cohort
    end
  end

end
