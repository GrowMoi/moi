module Tutor
  class DashboardStudentsSerializer < ActiveModel::Serializer
    attributes :id,
        :name,
        :username,
        :status,
        :created_at

    def status
      tutor_request = scope.tutor_requests_sent.find_by(user_id: object.id)
      status = tutor_request.status ? true : false
      status
    end
  end
end
