require 'test_helper'

class ParserTest < ActiveSupport::TestCase
  test "it knows there is a classroom conflict" do
    parser = Parser.new("Classroom B", ClassroomB, "2015-11-10")
    parser.update_info
    assert_equal parser.modified_date, "2015-11-10"
  end

  test "it firgures out what day it is on its own" do
    parser = Parser.new("Classroom C", ClassroomC)
    parser.update_info
    assert_equal parser.modified_date, ""
    assert_equal parser.day_time, Time.now.asctime.split[0]
  end

  test "it outputs that it does not know when there is no teacher or cohort for a certain classroom" do
    parser = Parser.new("Big Workspace", BigWorkspace, "2015-11-10")
    parser.update_info
    assert_equal parser.modified_date, "2015-11-10"
    assert_equal BigWorkspace.first.teacher, "I Dunno :P    "
    assert_equal BigWorkspace.first.cohort, "Check Today!  "
  end

  test "it finds the ochort and teacher for Clasroom A" do
    parser  = Parser.new("Classroom A", ClassroomA, "2015-11-10")
    parser2 = Parser.new("Classroom A", ClassroomA, "2015-11-09")
    parser.update_info
    parser2.update_info
    assert_equal parser.modified_date, "2015-11-10"
    assert_equal parser2.modified_date, "2015-11-09"
  end

  test "it finds the ochort and teacher for Classroom C" do
    parser = Parser.new("Classroom C", ClassroomC, "2015-11-10")
    parser2 = Parser.new("Classroom C", ClassroomC, "2015-11-09")
    parser.update_info
    assert_equal parser.modified_date, "2015-11-10"
    assert_equal parser2.modified_date, "2015-11-09"
  end

  test "it finds the ochort and teacher for Classroom B" do
    parser = Parser.new("Classroom B", ClassroomB, "2015-11-10")
    parser2 = Parser.new("Classroom B", ClassroomB, "2015-11-09")
    parser.update_info
    assert_equal parser.modified_date, "2015-11-10"
    assert_equal parser2.modified_date, "2015-11-09"
  end

  test "it finds the ochort and teacher for the Big Workspace" do
    parser = Parser.new("Big Workspace", BigWorkspace, "2015-11-10")
    parser2 = Parser.new("Big Workspace", BigWorkspace, "2015-11-09")
    parser.update_info
    assert_equal parser.modified_date, "2015-11-10"
    assert_equal parser2.modified_date, "2015-11-09"
  end

  test "it figures out it is Sunday" do
    new_time = Time.local(2015, 11, 15, 05, 0, 0)
    Timecop.freeze(new_time)

    parser = Parser.new("Big Workspace", BigWorkspace).update_info

    friday_message = "Weekend!!!"
    weekend_message = "Check Today :D"

    assert_equal BigWorkspace.first.teacher, weekend_message.ljust(14, " ")
    assert_equal BigWorkspace.first.cohort, friday_message.ljust(14, " ")

    new_time == Time.now
    Timecop.return
  end

  test "it figures out it is Saturday" do
    new_time = Time.local(2015, 11, 14, 05, 0, 0)
    Timecop.freeze(new_time)

    parser = Parser.new("Big Workspace", BigWorkspace).update_info

    friday_message = "Weekend!!!"
    weekend_message = "Check Today :D"

    assert_equal BigWorkspace.first.teacher, weekend_message.ljust(14, " ")
    assert_equal BigWorkspace.first.cohort, friday_message.ljust(14, " ")

    new_time == Time.now
    Timecop.return
  end

  test "it figures out it is Friday" do
    new_time = Time.local(2015, 11, 13, 05, 0, 0)
    Timecop.freeze(new_time)

    parser = Parser.new("Classroom A", ClassroomA).update_info

    friday_message = "Weekend!!!"
    weekend_message = "Check Today :D"

    assert_equal ClassroomA.first.teacher, weekend_message.ljust(14, " ")
    assert_equal ClassroomA.first.cohort, friday_message.ljust(14, " ")

    new_time == Time.now
    Timecop.return
  end
end
