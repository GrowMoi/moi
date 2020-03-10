module Tutor
  class MoiController < BaseController

    expose(:all_clients) {
      if params[:search]
        UserClientSearch.new(q:params[:search]).results
      else
        User.where(:role => :cliente)
      end
    }

    expose(:my_clients) {
      current_user.tutor_requests_sent.accepted.map &:user
    }

    expose(:clients) {
      all_clients.where.not(
        id: my_clients.map(&:id)
      ).page(params[:page])
    }

    def index
    end
  end
end
