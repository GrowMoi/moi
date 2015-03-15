class NeuronDecorator < LittleDecorator
  def decorated_contents
    @decorated_contents ||= decorate(contents)
  end

  def parent_title
    if parent_id
      title = Neuron.find(parent_id).title
    end
  end
end
