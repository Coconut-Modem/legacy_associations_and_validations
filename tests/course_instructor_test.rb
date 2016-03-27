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

  def test_can_create_a_course_instructor
    instructor = CourseInstructor.create
    assert CourseInstructor
  end

  def test_course_instructor_id_exists
    instructor = CourseInstructor.create
    assert_equal true, instructor.id?
  end

  def test_can_assign_course_to_instructor
    instructor = CourseInstructor.create
    course = Course.create(name: "Coding 101")
    instructor.add_course(course)
    assert_equal instructor.course_id, course.id
  end

  def test_course_not_destroyable_if_instructor_exists
    instructor = CourseInstructor.create
    course = Course.create(name: "Coding 101")
    instructor.add_course(course)
    assert_raises(ActiveRecord::DeleteRestrictionError) {course.destroy}
  end

end
