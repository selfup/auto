class DbParseUpdater

  attr_reader :endpoint_model

  def initialize(endpoint_model)
    @endpoint_model = endpoint_model
  end

  def cohort(cohort_num, teacher)
    endpoint_model.first.update(
                                cohort: cohort_num.ljust(14, " "),
                                teacher: teacher.first.ljust(14, " ")
                               )
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
end
