# Basic test requires
require 'minitest/autorun'
require 'minitest/pride'

# Include both the migration and the app itself
require './migration'
require './application'
require 'pry'

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

  def test_truth
    assert true
  end

  def test_term_class_exists
    assert Term
  end

  def test_term_has_an_id?
    school = School.create(name: "The Iron Yard")
    fall_term = Term.create(name: "Fall Term", starts_on: "2016-03-15 19:21:24 UTC", ends_on: "2016-05-31 19:21:24 UTC", school_id: 1)
    school.add_term_to_school(fall_term)
    assert_equal true, fall_term.id?
  end

  def test_term_must_have_name_start_date_end_date_and_school_id
    school = School.create(name: "The Iron Yard")
    term = Term.create(name: "Spring Term", starts_on: "2016-03-15 19:21:24 UTC", ends_on: "2016-05-31 19:21:24 UTC", school_id: 1)
    school.add_term_to_school(term)
    assert_equal true, term.valid?
  end

end
