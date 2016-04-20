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

  def test_course_cannot_be_destroyed_with_students
    course = Course.create(name: "Coding 101")
    student_one = CourseStudent.create(full_name: "Harry Potter")
    course.add_student(student_one)
    assert_raises(ActiveRecord::DeleteRestrictionError) {fall_term.destroy}
  end

  def test_assignments_are_destroyed_when_course_is_destroyed
    course = Course.create(name: "Coding 101")
    assignment_one = Assignment.create(name: "First Assignment")
    course.add_assignment(assignment_one)
    course.destroy
    assert_equal [], course.assignments
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

  def test_course_can_have_many_readings_through_lessons
    course = Course.create(name: "Coding 101")

    lesson_1 = Lesson.create(name: "How to Ruby")
    lesson_2 = Lesson.create(name: "How to JavaScript")

    course.add_lesson(lesson_1)
    course.add_lesson(lesson_2)

    reading_1 = Reading.create(caption: "Chapter 1")
    reading_2 = Reading.create(caption: "Chapter 2")
    reading_3 = Reading.create(caption: "Chapter 3")
    reading_4 = Reading.create(caption: "Chapter 4")

    lesson_1.add_reading(reading_1)
    lesson_1.add_reading(reading_2)
    lesson_2.add_reading(reading_3)
    lesson_2.add_reading(reading_4)

    assert_equal [reading_1, reading_2, reading_3, reading_4], course.readings
  end

  def test_course_code_is_unique
    Term.create(name: "Fall Term", starts_on: "2016-03-15 19:21:24 UTC", ends_on: "2016-05-31 19:21:24 UTC", school_id: 1)
    course_one = Course.create(name: "Defense against the Dark Arts")
    course_two = Course.create(name: "Quidditch 101" )
    refute_equal course_one, course_two
  end

end
