class ClassroomB < ActiveRecord::Base

  def self.update_info
    if Parser.new("Classroom B", self).conflict? == "Conflict!"
      Parser.new("Classroom B", self).conflicting_cohorts
    else
      Parser.new("Classroom B", self).find_b
    end
  end

end
