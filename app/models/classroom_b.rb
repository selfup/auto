class ClassroomB < ActiveRecord::Base

  def date
    Time.now.to_s.split(" ")[0]
  end

  def doc
    Nokogiri::HTML(open("http://today.turing.io/outlines/#{date}"))
  end

  def cohort_for_classroom_b
    # something goes here
  end

  def teacher_for_classroom_b
    # something goes here
  end

  def self.cohort
    ClassroomB.update(cohort: cohort_for_classroom_b)
  end

  def self.teacher
    ClassroomB.update(teacher: teacher_for_classroom_b)
  end

  def update_info
    cohort
    teacher
  end

end
