module Api
  class NotificationsController < BaseController
    PER_PAGE = 2

    before_action :authenticate_user!

    before_action :generic_notifications

    expose(:user_tutors) {
      current_user.tutor_requests_received
                  .includes(:tutor)
                  .pending
                  .order(:id)
                  .page(params[:page] || 1)
                  .per(params[:per_page] || PER_PAGE)
    }

    expose(:generic_notifications) {
      Notification.all
                  .includes(:notification_links)
                  .includes(:notification_medium)
                  .includes(:notification_videos)
                  .order(created_at: :desc)
                  .page(params[:page] || 1)
                  .per(params[:per_page] || PER_PAGE)
    }

    api :GET,
        "/notifications/new",
        "get new notifications for current user"
    example %q{
      // pending user tutor request
      {
        "user_tutors":[
          {
            "id":1,
            "status":null,
            "tutor": {
              "id":2,
              "email":"user-2@moi.org",
              "name":"User 2",
              "role":"cliente",
              "uid":"user-2@moi.org",
              "provider":"email",
              "country":null,
              "birthday":null,
              "city":null,
              "tree_image":null,
              "content_preferences":[
                {
                  "kind":"que-es",
                  "level":1,
                  "order":0
                },
                {
                  "kind":"como-funciona",
                  "level":1,
                  "order":1
                },
                {
                  "kind":"por-que-es",
                  "level":1,
                  "order":2
                },
                {
                  "kind":"quien-cuando-donde",
                  "level":1,
                  "order":3
                }
              ]
            }
          }
        ]
      }
    }
    def new
      serialized_user_tutors = ActiveModel::ArraySerializer.new(
        user_tutors,
        each_serializer: Api::UserTutorSerializer
      )
      render json: {
        user_tutors: serialized_user_tutors,
        meta: {
          total_count: user_tutors.total_count,
          total_pages: user_tutors.total_pages
        }
      }
    end

    api :GET,
        "/notifications/generic",
        "get generic notifications"
        example %q{
          {
            "notifications": [
              {
                "id": 6,
                "title": "Libero debitis et ea sunt temporibus",
                "description": "Adipisci eligendi eos molestiae dolorem nostrum eu",
                "user_id": 1,
                "links": [
                  "http://google.com"
                ],
                "videos": [
                  "https://www.youtube.com/watch?v=exneSCE60AY"
                ],
                "media": [
                  "1500831441-7.jpg",
                  "1500831441-download.jpg"
                ]
              },
              {
                "id": 3,
                "title": "Dicta omnis dolor mollitia similique",
                "description": "Beatae magnam aut ut est est nostrum ipsum consequuntur cum libero sed",
                "user_id": 1,
                "links": [
                  "http://google.com"
                ],
                "videos": [
                  "Ducimus non quis aut exercitation in ipsum est dolore est perferendis sunt et fuga Earum est sunt ut at dolor"
                ],
                "media": []
              },
              {
                "id": 2,
                "title": "Deserunt et sit ratione aut id sed iure proident non ut eu cillum minim recusandae Fugiat ut proident",
                "description": "Quo nulla unde quas debitis aliquam exercitation nulla dignissimos qui lorem dolor ea do quisquam",
                "user_id": 1,
                "links": [],
                "videos": [
                  "Facilis voluptatem vitae est assumenda vel quasi repellendus Exercitation inventore itaque"
                ],
                "media": []
              }
            ],
            "meta": {
              "total_count": 4,
              "total_pages": 2
            }
          }
    }
    def generic
      serialized_user_tutors = ActiveModel::ArraySerializer.new(
        generic_notifications,
        each_serializer: Api::GenericNotificationSerializer
      )
      render json: {
        notifications: serialized_user_tutors,
        meta: {
          total_count: generic_notifications.total_count,
          total_pages: generic_notifications.total_pages
        }
      }
    end
  end
end
