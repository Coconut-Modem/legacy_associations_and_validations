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
    lesson = Lesson.create(name: "Ruby")
    reading = Reading.create(order_number: 1, lesson_id: lesson.id, url: "http://www.google.com")
    assert_equal true, reading.id?
  end

  def test_can_retrieve_lesson_caption
    reading = Reading.create(caption: "Chapter 1")
    assert_equal "Chapter 1", reading.caption
  end

  def test_reading_must_have_order_number_lesson_id_and_url
    lesson =  Lesson.create(name: "Ruby")
    reading_one = Reading.create(order_number: 1, lesson_id: lesson.id, url: "http://www.google.com")
    reading_two = Reading.create(order_number: 2, lesson_id: lesson.id)

    assert_equal false, reading_two.valid?
    assert_equal true, reading_one.valid?
  end

  def test_reading_has_correct_syntax
    lesson =  Lesson.create(name: "Ruby")
    reading_one = Reading.create(order_number: 1, lesson_id: lesson.id, url: "http://www.google.com")
    reading_two = Reading.create(order_number: 2, lesson_id: lesson.id, url: "smtp://www.google.com")

    assert_equal true, reading_one.valid?
    assert_equal false, reading_two.valid?
  end

end
