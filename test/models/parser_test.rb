require 'test_helper'

class ParserTest < ActiveSupport::TestCase
  test "there is a conflict" do
    parser = Parser.new("Classroom B", ClassroomB, "2015-11-10")
    parser.update_info
    assert parser
  end

  test "it is the weekend" do
    parser = Parser.new("Classroom B", ClassroomB, "2015-11-13")
    parser.update_info
    assert parser
  end

  test "it firgures out what day it is on its own" do
    parser = Parser.new("Big Workspace", BigWorkspace)
    parser.update_info
    assert parser
  end

  test "the machine doesn't know" do
    parser = Parser.new("Big Workspace", BigWorkspace, "2015-11-10")
    parser.update_info
    assert parser
  end

  test "Clasroom A" do
    parser = Parser.new("Classroom A", ClassroomA, "2015-11-10")
    parser.update_info
    assert parser
  end

  test "Classroom C" do
    parser = Parser.new("Classroom C", ClassroomC, "2015-11-10")
    parser.update_info
    assert parser
  end
end
