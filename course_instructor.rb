class CourseInstructor < ActiveRecord::Base
  belongs_to :course

  def add_course(new_course)
    self.update(:course_id => new_course.id)
  end
end
