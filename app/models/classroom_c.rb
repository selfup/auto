class ClassroomC < ActiveRecord::Base
  def self.update_info
    Parser.new("Classroom C", self).update_info
  end
end
