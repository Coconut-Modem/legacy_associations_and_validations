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

    def test_term_cannot_be_deleted_with_courses
      term = Term.create!(name: "Spring", starts_on: )
      course = Course.create!(name: "Ruby on Rails")
      term.add_course(course)
      assert_raises (ActiveRecord::DeleteRestrictionError) {term.destroy}
    end

    def test_term_cannot_be_deleted_with_students
      term = Term.create!
      course_student = CourseStudent.create(student_id: 1)
      term.add_student(course_student)
      assert_raises (ActiveRecord::DeleteRestrictionError) {term.destroy}
    end

    def test_assignments_are_destroyed_when_course_is_destroyed
      course = Course.create!(name: "Ruby for Dummies")
      assignment_one = Assignment.create(name: "Section 1")
      assignment_two = Assignment.create(name: "Section 2")
      course.add_assignment(assignment_one)
      course.add_assignment(assignment_two)
      course.destroy
      assert_equal [], course.assignments
    end

end
