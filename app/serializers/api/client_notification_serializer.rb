module Api
  class ClientNotificationSerializer < ActiveModel::Serializer
    attributes :id,
        :data_type,
        :data,
        :created_at

    has_one :client

    def client
      ClientSerializer.new(object.client)
    end
  end
end
