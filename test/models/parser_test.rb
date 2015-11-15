require 'test_helper'

class ParserTest < ActiveSupport::TestCase
  test "there is a conflict" do
    parser = Parser.new("Classroom B", ClassroomB, "2015-11-10")
    parser.update_info
    assert_equal parser.modified_date, "2015-11-10"
  end

  test "it is the weekend" do
    parser = Parser.new("Classroom B", ClassroomB, "2015-11-13")
    parser.update_info
    assert_equal parser.modified_date, "2015-11-13"
    assert_equal ClassroomB.first.teacher, "Check Today :D"
    assert_equal ClassroomB.first.cohort, "Weekend!!!    "
  end

  test "it firgures out what day it is on its own" do
    parser = Parser.new("Big Workspace", BigWorkspace)
    parser.update_info
    assert_equal parser.modified_date, ""
    assert_equal parser.day_time, Time.now.asctime.split[0]
  end

  test "the machine doesn't know" do
    parser = Parser.new("Big Workspace", BigWorkspace, "2015-11-10")
    parser.update_info
    assert_equal parser.modified_date, "2015-11-10"
    assert_equal BigWorkspace.first.teacher, "I Dunno :P    "
    assert_equal BigWorkspace.first.cohort, "Check Today!  "
  end

  test "Clasroom A" do
    parser = Parser.new("Classroom A", ClassroomA, "2015-11-10")
    parser.update_info
    assert_equal parser.modified_date, "2015-11-10"
  end

  test "Classroom C" do
    parser = Parser.new("Classroom C", ClassroomC, "2015-11-10")
    parser.update_info
    assert_equal parser.modified_date, "2015-11-10"
  end
end
