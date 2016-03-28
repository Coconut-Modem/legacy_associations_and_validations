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

  def test_can_create_a_new_lesson
    lesson = Lesson.create(name: "How to Ruby")
    assert Lesson
  end

  def test_lesson_id_exists
    lesson = Lesson.create(name: "How to Ruby")
    assert_equal true, lesson.id?
  end

  def test_can_retrieve_lesson_name
    lesson = Lesson.create(name: "How to Ruby")
    assert_equal "How to Ruby", lesson.name
  end

  def test_lesson_can_have_many_readings
    lesson = Lesson.create(name: "How to Ruby")
    reading_1 = Reading.create(caption: "Chapter 1")
    reading_2 = Reading.create(caption: "Chapter 2")

    lesson.add_reading(reading_1)
    lesson.add_reading(reading_2)

    assert_equal [reading_1, reading_2], lesson.readings
  end

  def test_readings_are_destroyed_when_lesson_is_destroyed
    lesson = Lesson.create(name: "How to JavaScript")
    reading_3 = Reading.create(caption: "Chapter 3")
    reading_4 = Reading.create(caption: "Chapter 4")
    lesson.add_reading(reading_3)
    lesson.add_reading(reading_4)
    lesson.destroy
    assert_equal [], lesson.readings
  end

  def test_lesson_can_have_in_class_assignment
    course = Course.create(name: "Mobile Apps")
    assignment = Assignment.create(course_id: course.id, name: "Download Xcode", percent_of_grade: 12.75)
    lesson = Lesson.create(name: "How to Swift", in_class_assignment_id: assignment.id)

    assert_equal assignment.id, lesson.in_class_assignment_id
  end

end
