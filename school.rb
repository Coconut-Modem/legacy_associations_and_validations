require 'active_record'


class School < ActiveRecord::Base
  has_many :terms



  # has_many :courses, :through => :terms

  default_scope { order('name') }

  def add_term_to_school
    self.terms << new_term
  end

end
