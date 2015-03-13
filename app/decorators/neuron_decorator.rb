class NeuronDecorator < LittleDecorator
  def decorated_contents
    @decorated_contents ||= decorate(contents)
  end
end
