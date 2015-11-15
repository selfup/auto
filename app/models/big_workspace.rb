class BigWorkspace < ActiveRecord::Base
  def self.update_info
    Parser.new("Big Workspace", self).update_info
  end
end
