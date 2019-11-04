module Api
  module Users
    class PacificoRecoverPasswordsController < BaseController
      api :GET,
        "/users/pacifico_recover_password/validate",
        "get 4 contents to validate user"
        param :username, String
        param :birth_year, Integer
        example %q{
          {
            "contents": [
              {
                  "title": "¿Cuándo surgieron los Bancos?",
                  "id": 15
              },
              {
                  "title": "¿Qué son los medios necesarios?",
                  "id": 16
              },
              {
                  "title": "¿Qué más nos ayuda a cumplir nuestros sueños?",
                  "id": 17
              },
              {
                  "title": "¿Por qué son importantes los sueños?",
                  "id": 15
              }
          ],
          "user_id": 139,
          "content_reading_id": 469
        }
      }

      def validate
        user = User.where(username: params[:username], birth_year: params[:birth_year]).first
        unless user.nil?
          content_reading = last_content_reading(user)
          unless content_reading.nil?
            render json: {
              contents: get_contents(user).map{|c| {title: c.title, id: c.id}},
              user_id: user.id,
              content_reading_id: content_reading.id
            },
            status: 200
          else
            render json: {
              message: "Por favor contacta al administrador"
            },
            status: 404
          end
        else
          render json: {
                    message: "No hemos podido encontrar tu usuario"
                  },
                  status: 404
        end
      end

      api :GET,
          "/users/pacifico_recover_password/recover",
          "recover password user pacifico"
      param :user_id, Integer
      param :content_reading_id, Integer
      param :content_id, Integer
      example %q{
        {
         "key": "plants"
        }
      }

      def recover
        if params[:user_id] && params[:content_reading_id] && params[:content_id]
          user = User.find_by_id(params[:user_id])
          content_reading = ContentReading.find_by_id(params[:content_reading_id])
          if user && content_reading && content_reading.user_id == user.id && content_reading.content_id == params[:content_id].to_i
            render json: {
              key: user.authorization_key
            },
            status: 200
          else
            render json: {
                    message: "No hemos podido recuperar tu contraseña"
                  },
                  status: 404
          end
        else
            render json: {
                    message: "Parametros incorrectos"
                  },
                  status: 404
        end
      end

      private 

      def last_content_reading(user)
        user.content_readings.last ? user.content_readings.last : nil;
      end

      def get_contents(user)
        content = user.content_readings.last ? user.content_readings.last.content : nil;
        contents = Content.last(3);
        contents = contents << content
      end
    end
  end
end
