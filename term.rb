require 'active_record'



class Term < ActiveRecord::Base
  belongs_to :school
  has_many :courses, dependent: :restrict_with_exception
  has_many :course_students, dependent: :restrict_with_exception
  has_many :assignments, dependent: :destroy
  validates :name, :starts_on, :ends_on, :school_id, presence: true


  default_scope { order('ends_on DESC') }

  scope :for_school_id, ->(school_id) { where("school_id = ?", school_id) }

  def school_name
    school ? school.name : "None"
  end

  def add_course(new_course)
    self.courses << new_course
  end

  def add_assignment(new_assignment)
    self.assignments << new_assignment
  end
end
