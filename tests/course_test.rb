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

  def test_can_create_a_new_course
    course = Course.create(name: "Coding 101")
    assert Course
  end

  def test_course_id_exists
    course = Course.create(name: "Coding 101")
    assert_equal true, course.id?
  end

  def test_can_retrieve_course_name
    course = Course.create(name: "Coding 101")
    assert_equal "Coding 101", course.name
  end

  def test_course_can_have_many_lessons
    course = Course.create(name: "Coding 101")
    lesson_1 = Lesson.create(name: "How to Ruby")
    lesson_2 = Lesson.create(name: "How to JavaScript")

    course.add_lesson(lesson_1)
    course.add_lesson(lesson_2)

    assert_equal [lesson_1, lesson_2], course.lessons
  end

  def test_lessons_are_destroyed_when_course_is_destroyed
    course = Course.create(name: "Coding 101")
    lesson_1 = Lesson.create(name: "How to Ruby")
    lesson_2 = Lesson.create(name: "How to JavaScript")
    course.add_lesson(lesson_1)
    course.add_lesson(lesson_2)
    course.destroy
    assert_equal [], course.lessons
  end

end
