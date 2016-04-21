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

  def test_assignments_must_have_course_id_name_and_percent_of_grade
    course_one = Course.create(name: "Coding 101")
    assignment_1 = Assignment.create(course_id: 1, name: "Learn stuff", percent_of_grade: 10.25)
    assignment_2 = Assignment.create(course_id: course_one.id, percent_of_grade: 10.00)

    assert_equal true, assignment_1.valid?
    assert_equal false, assignment_2.valid?
  end

  def test_assignment_name_must_be_unique
    course = Course.create(name: "Coding 101")
    assignment_3 = Assignment.create(course_id: course.id, name: "Code things", percent_of_grade: 12.75)
    assignment_4 = Assignment.create(course_id: course.id, name: "Code stuff", percent_of_grade: 15.32)

    assert_equal false, assignment_4.valid?
  end

end
