module Api
  class NotificationsController < BaseController
    before_action :authenticate_user!

    expose(:user_tutors) {
      current_user.tutor_requests_received
                  .includes(:tutor)
                  .pending
    }

    api :GET,
        "/notifications/new",
        "get new notifications for current user"
    example %q{
      // pending user tutor request
      {"user_tutors":[{"id":1,"status":null,"tutor":{"id":2,"email":"user-2@moi.org","name":"User 2","role":"cliente","uid":"user-2@moi.org","provider":"email","country":null,"birthday":null,"city":null,"tree_image":null,"content_preferences":[{"kind":"que-es","level":1,"order":0},{"kind":"como-funciona","level":1,"order":1},{"kind":"por-que-es","level":1,"order":2},{"kind":"quien-cuando-donde","level":1,"order":3}]}}]}
    }
    def new
      serialized_user_tutors = ActiveModel::ArraySerializer.new(
        user_tutors,
        each_serializer: Api::UserTutorSerializer
      )
      render json: {
        user_tutors: serialized_user_tutors
      }
    end
  end
end
