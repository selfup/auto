class ClassroomA < ActiveRecord::Base

  def self.update_info
    if Parser.new("Classroom A", self).conflict? == "Conflict!"
      Parser.new("Classroom A", self).conflicting_cohorts
    else
      Parser.new("Classroom A", self).find_b
    end
  end

end
