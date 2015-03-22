class NeuronDecorator < LittleDecorator
  def parent_title
    parent.try :title
  end

  def parent
    @parent ||= Neuron.find(
      parent_id
    ) if parent_id.present?
  end
end
