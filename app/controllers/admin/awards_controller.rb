module Admin
  class AwardsController < AdminController::Base
    authorize_resource

    expose(:award, attributes: :award_params)

    def index
      #@awards = UserAward.where(user: current_user).order(created_at: :desc)
      @awards = Award.all.order(created_at: :desc)
      render
    end

    def new
      render
    end

    def create
      if award.save
        redirect_to admin_awards_path
      else
        render :new
      end
    end

    private

    def award_params

      params.require(:award).permit(
        :name,
        :description,
        :image
      )
    end
  end
end
