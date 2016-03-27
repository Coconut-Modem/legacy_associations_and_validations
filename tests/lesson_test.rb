# Basic test requires
require 'minitest/autorun'
require 'minitest/pride'

# Include both the migration and the app itself
require './migration'
require './application'

# Overwrite the development database connection with a test connection.
ActiveRecord::Base.establish_connection(
  adapter:  'sqlite3',
  database: 'test.sqlite3'
)

# Gotta run migrations before we can run tests.  Down will fail the first time,
# so we wrap it in a begin/rescue.
begin ApplicationMigration.migrate(:down); rescue; end
ApplicationMigration.migrate(:up)


# Finally!  Let's test the thing.
class ApplicationTest < Minitest::Test

  # def test_can_create_a_new_lesson
  #   lesson = Lesson.create(name: "How to Ruby")
  #   assert Lesson
  # end
  #
  # def test_lesson_id_exists
  #   lesson = Lesson.create(name: "How to Ruby")
  #   assert_equal true, lesson.id?
  # end
  #
  # def test_can_retrieve_lesson_name
  #   lesson = Lesson.create(name: "How to Ruby")
  #   assert_equal "How to Ruby", lesson.name
  # end
  #
  # def test_lesson_can_have_many_readings
  #   lesson = Lesson.create(name: "How to Ruby")
  #   reading_1 = Reading.create(caption: "Chapter 1")
  #   reading_2 = Reading.create(caption: "Chapter 2")
  #
  #   lesson.add_reading(reading_1)
  #   lesson.add_reading(reading_2)
  #
  #   assert_equal [reading_1, reading_2], lesson.readings
  # end
  #
  # def test_readings_are_destroyed_when_lesson_is_destroyed
  #   lesson = Lesson.create(name: "How to JavaScript")
  #   reading_1 = Reading.create(caption: "Chapter 3")
  #   reading_2 = Reading.create(caption: "Chapter 4")
  #   lesson.add_reading(reading_1)
  #   lesson.add_reading(reading_2)
  #   lesson.destroy
  #   assert_equal [], lesson.readings
  # end

  def test_lesson_can_have_many_in_class_assignments
    lesson = Lesson.create(name: "How to Python")

    assignment_1 = Assignment.create(name: "Write a class", in_class_assignment: true)
    assignment_2 = Assignment.create(name: "Write a method for a class", in_class_assignment: true)

    lesson.add_assignment(assignment_1)
    lesson.add_assignment(assignment_2)

    assert_equal [assignment_1, assignment_2], lesson.assignments
  end

  def test_lesson_can_have_many_pre_class_assignments
  end

  def test_lesson_can_have_a_mix_of_assignment_types
  end

end
