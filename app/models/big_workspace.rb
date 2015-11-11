class BigWorkspace < ActiveRecord::Base

  def self.update_info
    if Parser.new("Big Workspace", self).conflict? == "Conflict!"
      Parser.new("Big Workspace", self).conflicting_cohorts
    else
      Parser.new("Big Workspace", self).find_b
    end
  end

end
