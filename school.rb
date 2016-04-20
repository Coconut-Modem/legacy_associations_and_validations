require 'active_record'


class School < ActiveRecord::Base
  has_many :terms
  has_many :courses, through: :terms
  validates :name, presence: true

  default_scope { order('name') }

  def add_term_to_school(new_term)
    self.terms << new_term
  end

end
