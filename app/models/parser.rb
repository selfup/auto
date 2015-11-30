class Parser
  attr_reader :location, :endpoint_model, :mod_date, :content, :elements, :data,
              :date, :day_time, :weekend, :cohorts, :teachers, :rooms, :link_up

  def initialize(location, endpoint_model, mod_date = "")
    @location       = location
    @endpoint_model = endpoint_model
    @mod_date       = mod_date
    @data           ||= {}
    @teacher        = ["Unknown"]
    @cohorts        = %w(1507 1508 1510 1511)
    @teachers       = %w(Jeff Josh Rachel Jorge Steve Horace Andrew Mike Tess)
    @day_time       = DayTracker.new.day_time
    @date           = DayTracker.new.date
    @weekend        = DayTracker.new(weekend!).weekend
    @content        = ContentFetcher.new(mod_date, date).content
    @elements       = ContentFetcher.new(mod_date, date).elements
    @rooms          = ContentFetcher.new(mod_date, date, cohorts, data).rooms
    @link_up        = ContentFetcher.new(mod_date, date, cohorts, data).link_up
  end

  def module_1
    data[cohorts[3]][2]
  end

  def module_2
    data[cohorts[2]][2]
  end

  def module_3
    data[cohorts[1]][2]
  end

  def module_4
    data[cohorts[0]][2]
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
      find_teacher(module_1); cohort(cohorts[3])
    elsif module_2.include?(@location)
      find_teacher(module_2); cohort(cohorts[2])
    elsif module_3.include?(@location)
      find_teacher(module_3); cohort(cohorts[1])
    elsif module_4.include?(@location)
      find_teacher(module_4); cohort(cohorts[0])
    else
      DbParseUpdater.new(endpoint_model).tbd
    end
  end

  def find_teacher(mod_teacher)
    mod_teacher.split(" ").map do |find|
      if teachers.include?(find)
        return @teacher.unshift(find)
      end
    end
  end

  def cohort(cohort_num)
    DbParseUpdater.new(endpoint_model).cohort(cohort_num, @teacher)
  end

  def weekend!
    DbParseUpdater.new(endpoint_model).weekend!
  end

  def update_info
    link_up
    if weekend
      weekend!
    elsif conflict? == "Conflict!"
      DbParseUpdater.new(endpoint_model).conflicting_cohorts
    else
      find_cohort
    end
  end
end
