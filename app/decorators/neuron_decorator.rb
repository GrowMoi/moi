class NeuronDecorator < LittleDecorator
  def parent_title
    parent.try :title
  end

  def parent
    @parent ||= Neuron.find(
      parent_id
    ) if parent_id.present?
  end

  def contents_approved_disappoved
    content_tag(:span, contents.approved(:false).count,
                class: "label label-danger bs-tooltip",
                title: t("views.contents.by_approve"),
                data: {placement: "bottom" }) +
    content_tag(:span, contents.approved.count,
                class: "label label-success bs-tooltip",
                title: t("views.contents.approve").pluralize,
                data: {placement: "bottom" })
  end

  def status_label
    type = is_public ? "success" : "default"
    content_tag :span,
                class: "label label-#{type}" do
      I18n.t("views.neurons.public_status.#{is_public}")
    end
  end
end
