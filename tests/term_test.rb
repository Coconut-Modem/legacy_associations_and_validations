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
  def test_new_term_can_be_created
    fall_term = Term.create(name: "Fall Term")
  end

  def test_term_has_an_id?
    fall_term = Term.create(name: "Fall Term")
    assert_equal true, fall_term.id?
  end


end
