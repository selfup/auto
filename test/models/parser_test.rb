require 'test_helper'

class ParserTest < ActiveSupport::TestCase

  def class_room_data_stuff
    {"1505"=>["1505", "FINAL ASSESSMENT (All Day)", "The Final Countdown", "Meet in Classroom C where Steve will give you the deets.", "1507"], "1507"=>["1507", "Project Work Time (All Day)", "You can do it.", "1508"], "1508"=>["1508", "Module 2 Assessments (9:00 - 12:00)", "With Andrew", "9:00 - Jason Pilz", "9:45 - Matt Stjernholm", "10:30 - Matt Rooney", "With Rachel", "9:00 - Sekhar Paladugu", "9:45 - Edgar Duran", "10:30 - Charissa Lawrence", "With Mike", "9:00 - Emily Dowdle", "9:45 - Shannon Paige", "10:30 - Robbie Lane", "1510"], "1510"=>["1510", "Boolean Logic Deep Dive (9:00 - 10:30)", "Join Jeff in Classroom A where we'll learn about Boolean Logic.", "Project Work Time (10:30 - 4:00)", "Stay in Classroom A.", "Project Work Time (1:00 - 4:00)", "In the 10:30-12:00 area Jeff will be working on gathering/posting missing data about your past projects. Horace will be available for questions, especially fixes/additions to the spec harness.", "© Copyright 2015 Turing School of Software & Design, All rights reserved"]}
  end

  def clean_up_data
    ["20151112", "Turing School of Software & Design", "Today", "All Outlines", "Main Site", "2015-11-12", "Today, in 1990, Tim Berners-Lee publishes a formal proposal for the World Wide Web.", "All", "Posse Clean-Up Duty (After Wrapup)", "Today: Ritchie Posse", "Take 15 minutes after wrap-up to check the items on this list.", "Warm Up (8:30 - 9:00)", "Warm Up", "Pull requests accepted.", "Intro to SQL (Names are Below)", "Join Nate in Classroom B", "Lesson Plan", "Dan Winter", "Brenna Martenson", "Alex Navarrete", "Shannon Paige", "Ross Edfort", "Robbie Lane", "Steven Olson", "Gregory Armstrong", "Jhun de Andres", "Sekhar Paladugu", "Jason Pilz", "Ryan Johnson", "Emily Dowdle", "Brennan Holtzclaw", "Beth Sebian", "1505", "WebSocket Workshop (9:00 - 12:00)", "Meet with Tess is Classroom C.", "This morning, you'll be working through a guided implementation of a small WebSocket application that should look eerily familiar.", "Intra-cohort Check-Ins (1:00 - 2:00)", "It's time to take a look at each other's implementations. For the first hour this afternoon, you'll be reviewing a classmate's implementation. Please spend half an hour reviewing each project.", "Leave feedback here.", "You'll work in the follow pairs:", "Rick Bacci & Alex Tideman", "Dave Maurer & Max Millington", "Jai Misra & Erik Butcher", "Samson Brock & Lovisa Svallingson", "Dmitry Vizersky & Marla Brizel", "Adam Caron & David Shim", "Sebastian Abondano & Jamie Kawahara", "Project Work Time (2:00 - 4:00)", "Tess is on hand for all of your questioning needs.", "1507", "Project Work Time (9:00 - 12:00)", "Project Check-Ins and Work Time (1:00 - 4:00)", "With Jorge", "Matt Hecker & Alon Waisman", "Russell Harms", "Rose Kohn", "Matt Ewell", "Michael Wong", "Travis Haby & Mimi Schatz", "Mary Beth Burch & George Hudson", "Jeff Ruane & Chris Cenatiempo", "With Josh", "Ryan Asensio", "Jerrod Paul Junker", "Adam Jensen", "Regis Boudinot", "Bret Doucette", "Justin Holzmann", "Jason Wright", "Stanley Siudzinski", "1508", "Pushing Logic Down the Stack (9:00 - 10:30)", "Join Jeff in Classroom B to Push Logic Down the Stack.", "Little Shop Check-Ins and Work Time (10:30 - 4:00)", "One-on-Ones", "With Rachel:", "10:40 Tyler Komoroske", "10:50 Ryan Johnson", "11:00 Torie Warren", "11:10 Sekhar Paladugu", "11:20 Pat Wey", "11:30 Matt Stjernholm", "11:40 Amber Crawford", "With Andrew:", "10:40 Edgar Duran", "10:50 Marlo Major", "11:00 Emily Dowdle", "11:10 Shannon Paige", "11:20 Robbie Lane", "11:30 Ross Edfort", "Little Shop Check-Ins", "With Rachel:", "1:00 Jhun de Andres & Ryan Johnson & Charissa Lawrence", "1:45 Edgar Duran & Matt Rooney & Matt Stjernholm", "2:30 John Slota & Amber Crawford & Shannon Paige", "3:15 Emily Dowdle & Jason Pilz & Sekhar Paladugu", "With Andrew:", "1:00 Jill Donohue & Pat Wey & Marlo Major", "1:45 Robbie Lane & Tyler Komoroske & Ross Edfort", "2:30 Aaron Careaga & Torie Warren & Nicole Hall", "1510", "Work Time & Instructor Pairing", "Today's going to be a heavy work day. Push forward on your project together, and each pair is going to work with an instructor for an hour. Find your slot below.", "With Jeff", "1:00 - Steve Pentler & Jordan Lawler", "2:00 - Toni Rib & Aaron Greenspan", "With Mike", "9:00 - Hector Huertas Baeza & Taylor Moore", "10:00 - Lenny Myerson & Brant Wellman", "11:00 - Brennan Holtzclaw & Beth Sebian", "1:00 - Joseph Perry & Penney Garrett", "2:00 - Emily Blanchard", "With Horace", "9:00 - Greg Armstrong & Steven Olson", "10:00 - Brenna Martenson & Dan Winter", "11:00 - Alexis Uriel Navarrete & Admir Draganovic", "1:00 - James Crockett & Beth Secor", "1-on-1s", "We're also going to layer in some one-on-ones.", "With Jeff", "11:00 - Taylor Moore", "11:15 - Lenny Myerson", "11:30 - James Crockett", "11:45 - Toni Rib", "3:00 - Jordan Lawler", "3:15 - Brennan Holtzclaw", "3:30 - Dan Winter", "3:45 - Admir Draganovic", "With Horace", "2:15 - Alexis Uriel Navarrete", "2:30 - Steve Pentler", "2:45 - Beth Sebian", "3:00 - Joseph Perry", "3:15 - Emily Blanchard", "3:30 - Brenna Martenson", "With Mike", "3:15 - Aaron Greenspan", "3:30 - Hector Huertas Baeza", "Future 1-on-1s", "Greg Armstrong", "Beth Secor", "Penney Garrett", "Brant Wellman", "Steven Olson", "© Copyright 2015 Turing School of Software & Design, All rights reserved"]
  end

  test "it firgures out what day it is on its own" do
    new_time = Time.local(2015, 11, 12, 05, 0, 0)
    Timecop.freeze(new_time)
    parser = Parser.new("Classroom C", ClassroomC)
    parser.update_info

    assert_equal "", parser.mod_date
    assert_equal Time.now.asctime.split[0], parser.day_time
  end

  test "it fetches the data and cleans it up" do
    new_time = Time.local(2015, 11, 12, 05, 0, 0)
    Timecop.freeze(new_time)
    parser = Parser.new("Classroom C", ClassroomC, "2015-11-12")

    assert_equal Nokogiri::HTML::Document, parser.content.class
    assert_equal clean_up_data, parser.elements
    new_time == Time.now
    Timecop.return
  end

  test "it figures out how to link the data successfully" do
    new_time = Time.local(2015, 11, 12, 05, 0, 0)
    Timecop.freeze(new_time)
    parser = Parser.new("Classroom A", ClassroomA, "2015-11-18")

    assert_equal ["1505", "1507", "1508", "1510"], parser.link_up
    assert_equal class_room_data_stuff, parser.data
    new_time == Time.now
    Timecop.return
  end

  test "it outputs that it does not know when there is no teacher or cohort for a certain classroom" do
    new_time = Time.local(2015, 11, 12, 05, 0, 0)
    Timecop.freeze(new_time)
    parser = Parser.new("Big Workspace", BigWorkspace, "2015-11-10")

    parser.update_info

    assert_equal "2015-11-10", parser.mod_date
    assert_equal "I Dunno :P    ", BigWorkspace.first.teacher
    assert_equal "Check Today!  ", BigWorkspace.first.cohort
    new_time == Time.now
    Timecop.return
  end

  test "it finds the cohort and teacher for Clasroom A" do
    new_time = Time.local(2015, 11, 12, 05, 0, 0)
    Timecop.freeze(new_time)

    parser2 = Parser.new("Classroom A", ClassroomA, "2015-11-09")

    parser2.update_info

    assert_equal "2015-11-09", parser2.mod_date
    assert_equal "Jeff          ", ClassroomA.first.teacher

    assert_equal "2015-11-09", parser2.mod_date
    new_time == Time.now
    Timecop.return
  end

  test "it says I Dunno :P when it doesn't find a teacher or classroom for Classroom C" do
    new_time = Time.local(2015, 11, 12, 05, 0, 0)
    Timecop.freeze(new_time)
    parser = Parser.new("Classroom C", ClassroomC, "2015-11-10")

    parser.update_info

    assert_equal "2015-11-10", parser.mod_date
    assert_equal "I Dunno :P    ", ClassroomC.first.teacher
    new_time == Time.now
    Timecop.return
  end

  test "it finds a conflict for Classroom B" do
    new_time = Time.local(2015, 11, 12, 05, 0, 0)
    Timecop.freeze(new_time)
    parser = Parser.new("Classroom B", ClassroomB, "2015-11-10")

    parser.update_info

    assert_equal "Help          ", ClassroomB.first.teacher
    assert_equal "Conflict      ", ClassroomB.first.cohort
    assert_equal "2015-11-10", parser.mod_date
    new_time == Time.now
    Timecop.return
  end

  test "it says I Dunno :P when it doesn't find a teacher or classroom for the Big Workspace" do
    new_time = Time.local(2015, 11, 12, 05, 0, 0)
    Timecop.freeze(new_time)
    parser = Parser.new("Big Workspace", BigWorkspace, "2015-11-10")

    parser.update_info
    assert_equal "I Dunno :P    ", BigWorkspace.first.teacher
    assert_equal "2015-11-10", parser.mod_date
    new_time == Time.now
    Timecop.return
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
