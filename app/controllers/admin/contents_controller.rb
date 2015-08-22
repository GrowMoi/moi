module Admin
  class ContentsController < Neurons::BaseController
    expose(:content)

    def approve
      content.toggle! :approved
      redirect_to admin_neuron_path(content.neuron),
                  notice: t("views.contents.toggle_approve.#{content.approved}")
    end
  end
end
