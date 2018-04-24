module Tutor
  class UserTutorsController < TutorController::Base
    def create
      if current_user.super_tutor?
        add_new_students
      end

      if current_user.tutor?
        sent_new_requests
      end

      if request.xhr?
        render :js => "window.location = '#{request.referrer}'"
      else
        redirect_to :back
      end
    end

    private

    def add_new_students
      if params[:user_ids]
        user_ids = params[:user_ids]
        user_names = []
        user_ids.each do |id|
          tutor_request = current_user.tutor_requests_sent.new(
            user_id: id,
            status: :accepted
          )
          if tutor_request.save
            user_names.push(tutor_request.user.name)
          end
        end
        if user_names.any?
          flash[:success] = I18n.t(
            "views.tutor.moi.tutor_request.user_added",
            clients: user_names.join(", ")
          )
        else
          flash[:error] = I18n.t("views.tutor.moi.tutor_request.user_added_error")
        end
      end
    end

    def sent_new_requests
      if params[:user_id]
        tutor_request = current_user.tutor_requests_sent.new(
          user_id: params[:user_id]
        )
        if tutor_request.save
          flash[:success] = I18n.t(
            "views.tutor.moi.tutor_request.created",
            name: tutor_request.user.name
          )
        else
          flash[:error] = I18n.t(
            "views.tutor.moi.tutor_request.not_created",
            name: tutor_request.user.name
          )
        end
      end

      if params[:user_ids]
        user_ids = params[:user_ids]
        user_names = []
        user_ids.each do |id|
          tutor_request = current_user.tutor_requests_sent.new(
            user_id: id
          )
          if tutor_request.save
            user_names.push(tutor_request.user.name)
          end
        end
        if user_names.any?
          flash[:success] = I18n.t(
            "views.tutor.moi.tutor_request.created_list",
            clients: user_names.join(", ")
          )
        else
          flash[:error] = I18n.t("views.tutor.moi.tutor_request.not_created_list")
        end
      end
    end
  end
end
