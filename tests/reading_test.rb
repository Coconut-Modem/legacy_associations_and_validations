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

  def test_can_create_a_new_reading
    reading = Reading.create(caption: "Chapter 1")
    assert Reading
  end

  def test_reading_id_exists
    reading = Reading.create(caption: "Chapter 1")
    assert_equal true, reading.id?
  end

  def test_can_retrieve_lesson_caption
    reading = Reading.create(caption: "Chapter 1")
    assert_equal "Chapter 1", reading.caption
  end

end
