require 'active_record'

class Term < ActiveRecord::Base
  has_many :courses, dependent: :restrict_with_exception
  belongs_to :school
  validates :name, :starts_on, :ends_on, :school_id, presence: true

  default_scope { order('ends_on DESC') }

  scope :for_school_id, ->(school_id) { where("school_id = ?", school_id) }

  def school_name
    school ? school.name : "None"
  end

  def course_to_term(new_course)
    self.courses << new_course
  end

end
