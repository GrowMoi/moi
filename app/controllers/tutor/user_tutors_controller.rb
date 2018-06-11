module Tutor
  class UserTutorsController < TutorController::Base
    def create
      if current_user.admin?
        add_new_students
      end

      if current_user.tutor?
        sent_new_requests
      end

      if current_user.tutor_familiar?
        check_payment_and_sent_new_requests
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
        add_one_user
      end

      if params[:user_ids]
        add_many_user
      end
    end

    def check_payment_and_sent_new_requests
      product = Product.find_by_key("ACP")
      total_payments = Payment.where(user: current_user, code_item: product.code).sum(:quantity)
      total_my_users = current_user.tutor_requests_sent.count

      if total_payments > total_my_users
        if params[:user_id]
          add_one_user
        end

        if params[:user_ids]
          total_users = params[:user_ids].count + total_my_users
          if total_payments >= total_users
            add_many_user
          else
            flash[:error] = I18n.t("views.tutor.moi.tutor_request.cant_add_users",
                                    number: total_payments)
          end
        end
      else
        flash[:error] = I18n.t("views.tutor.moi.tutor_request.cant_add_users",
                                number: total_payments)
      end
    end


    def add_one_user
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

    def add_many_user
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
