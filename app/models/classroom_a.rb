class ClassroomA < ActiveRecord::Base
  def self.update_info
    Parser.new("Classroom A", self).update_info
  end
end
