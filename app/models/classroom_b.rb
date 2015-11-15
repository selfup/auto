class ClassroomB < ActiveRecord::Base
  def self.update_info
    Parser.new("Classroom B", self).update_info
  end
end
