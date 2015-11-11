class ClassroomC < ActiveRecord::Base

  def self.update_info
    if Parser.new("Classroom C", self).conflict? == "Conflict!"
      Parser.new("Classroom C", self).conflicting_cohorts
    else
      Parser.new("Classroom C", self).find_b
    end
  end

end
