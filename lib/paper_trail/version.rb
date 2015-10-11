module PaperTrail
  class Version < ::ActiveRecord::Base
    scope :reverse, lambda {
      scoped.merge(
        unscope(:order)
      ).order(id: :desc)
    }
  end
end
