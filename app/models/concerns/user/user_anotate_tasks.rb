class User < ActiveRecord::Base
  module UserAnotateTasks

    def create_tasks(content_id)
      user_task = Task.where(user_id: self.id, content_id: content_id)

      if user_task.empty?
        user_task = Task.new(user_id: self.id, content_id: content_id)
        user_task.save
        false
      else
        true
      end

    end
  end
end
