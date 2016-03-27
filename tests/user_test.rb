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

  def test_user_must_be_created_with_firstname_lastname_email
    user = User.create(first_name: "Nadia", last_name: "Barbosa", email: "nb@gmail.com")
    assert_equal true, user.valid?
  end

  def test_validate_user_has_unique_email
    user_1 = User.create(first_name: "Nadia", last_name: "Barbosa", email: "nb@gmail.com")
    user_2 = User.create(first_name: "Aidan", last_name: "Barbosa", email: "nb@gmail.com")

    assert_equal false, user_2.valid?
  end
end
