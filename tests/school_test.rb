# Basic test requires
require 'minitest/autorun'
require 'minitest/pride'
require 'active_record'
require 'pry'
# Include both the migration and the app itself
require './migration'
require './application'
require './school'


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

  def test_class_exists
    assert School
  end

  def test_school_can_be_created
    school = School.create(name: "The Iron Yard")
    assert_equal "The Iron Yard", school.name
  end

  def test_school_has_id?
    school = School.create(name: "The Iron Yard")
    assert_equal school.id?, true
  end

  def test_term_can_be_created
    new_term = Term.create(name: "Fall Term")
    assert_equal "Fall Term", new_term.name
  end

  def test_school_can_have_many_terms
    school = School.create(name: "The Iron Yard")
    term_one = Term.create(name: "Fall Term")
    term_two = Term.create(name: "Spring Term")

    school.add_term_to_school(term_one)
    school.add_term_to_school(term_two)
    assert_equal [term_one, term_two], school.terms
  end
end
