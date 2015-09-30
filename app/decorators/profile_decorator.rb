class ProfileDecorator < LittleDecorator
  def to_s
    record.name
  end

  def neurons
    @neurons ||= Neuron.where(id: record.neuron_ids)
  end
end
