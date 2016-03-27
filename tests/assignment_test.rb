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

  def test_assignment_can_be_created
    assignment = Assignment.create(name: "Write a Program")
    assert Assignment
  end

  def test_assignment_can_be_marked_as_in_class
    assignment = Assignment.create(name: "Write a Program", in_class_assignment: true)
    assert_equal true, assignment.in_class_assignment
  end

  def test_assignment_can_be_marked_as_pre_class
  end

end
