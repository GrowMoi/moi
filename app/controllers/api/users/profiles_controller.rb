module Api
  module Users
    class ProfilesController < BaseController
      respond_to :json

      expose(:user) {
        user = User.find_by_username(params[:username])
      }

      api :GET,
          "/users/profile",
          "Get basic information user"
      example %q{
        "id":6082,
        "email":"test1987@gmail.com",
        "name":null,
        "username":"test1987",
        "country":"Ecuador",
        "school":"Test School",
        "city":"Loja",
        "last_contents_learnt":[
          {
            "id":1246,
            "media":["http://localhost:5000/uploads/content_media/media/160/photosynthesis-powerpoint-8-728.jpg"],
            "title":"¿Cómo transforma energía la Naturaleza?",
            "neuron_id":2350
          }
        ]
        "test_without_errors":1,
        "content_summary":{
          "current_learnt_contents":10,
          "total_approved_contents":314
        }
      }
      def show
        respond_with(
          user,
          serializer: Api::UserProfileSerializer
        )
      end
    end
  end
end
