require 'test_helper'

class ParserTest < ActiveSupport::TestCase
  test "it knows there is a classroom conflict" do
    parser = Parser.new("Classroom B", ClassroomB, "2015-11-10")
    parser.update_info
    assert_equal "2015-11-10", parser.modified_date
  end

  test "it firgures out what day it is on its own" do
    parser = Parser.new("Classroom C", ClassroomC)
    parser.update_info

    assert_equal "", parser.modified_date
    assert_equal Time.now.asctime.split[0], parser.day_time
  end

  test "it outputs that it does not know when there is no teacher or cohort for a certain classroom" do
    parser = Parser.new("Big Workspace", BigWorkspace, "2015-11-10")

    parser.update_info

    assert_equal "2015-11-10", parser.modified_date
    assert_equal "I Dunno :P    ", BigWorkspace.first.teacher
    assert_equal "Check Today!  ", BigWorkspace.first.cohort
  end

  test "it finds the ochort and teacher for Clasroom A" do
    parser  = Parser.new("Classroom A", ClassroomA, "2015-11-10")
    parser2 = Parser.new("Classroom A", ClassroomA, "2015-11-09")

    parser.update_info

    assert_equal "2015-11-10", parser.modified_date
    assert_equal "Steve         ", ClassroomA.first.teacher
    assert_equal "1505          ", ClassroomA.first.cohort

    parser2.update_info

    assert_equal "2015-11-09", parser2.modified_date
    assert_equal "Jeff          ", ClassroomA.first.teacher

    assert_equal "2015-11-09", parser2.modified_date
  end

  test "it finds the cohort and teacher for Classroom C" do
    parser = Parser.new("Classroom C", ClassroomC, "2015-11-10")

    parser.update_info

    assert_equal "2015-11-10", parser.modified_date
    assert_equal "I Dunno :P    ", ClassroomC.first.teacher
  end

  test "it finds the cohort and teacher for Classroom B" do
    parser = Parser.new("Classroom B", ClassroomB, "2015-11-10")

    parser.update_info

    assert_equal "Help          ", ClassroomB.first.teacher
    assert_equal "2015-11-10", parser.modified_date
  end

  test "it finds the cohort and teacher for the Big Workspace" do
    parser = Parser.new("Big Workspace", BigWorkspace, "2015-11-10")
    parser2 = Parser.new("Big Workspace", BigWorkspace, "2015-11-09")

    parser.update_info

    assert_equal "2015-11-10", parser.modified_date
    assert_equal "2015-11-09", parser2.modified_date
  end

  test "it figures out it is Sunday" do
    new_time = Time.local(2015, 11, 15, 05, 0, 0)
    Timecop.freeze(new_time)

    parser = Parser.new("Big Workspace", BigWorkspace).update_info

    friday_message = "Weekend!!!"
    weekend_message = "Check Today :D"

    assert_equal weekend_message.ljust(14, " "), BigWorkspace.first.teacher
    assert_equal friday_message.ljust(14, " "), BigWorkspace.first.cohort

    new_time == Time.now
    Timecop.return
  end

  test "it figures out it is Saturday" do
    new_time = Time.local(2015, 11, 14, 05, 0, 0)
    Timecop.freeze(new_time)

    parser = Parser.new("Big Workspace", BigWorkspace).update_info

    friday_message = "Weekend!!!"
    weekend_message = "Check Today :D"

    assert_equal weekend_message.ljust(14, " "), BigWorkspace.first.teacher
    assert_equal friday_message.ljust(14, " "), BigWorkspace.first.cohort

    new_time == Time.now
    Timecop.return
  end

  test "it figures out it is Friday" do
    new_time = Time.local(2015, 11, 13, 05, 0, 0)
    Timecop.freeze(new_time)

    parser = Parser.new("Classroom A", ClassroomA).update_info

    friday_message = "Weekend!!!"
    weekend_message = "Check Today :D"

    assert_equal weekend_message.ljust(14, " "), ClassroomA.first.teacher
    assert_equal friday_message.ljust(14, " "), ClassroomA.first.cohort

    new_time == Time.now
    Timecop.return
  end
end
