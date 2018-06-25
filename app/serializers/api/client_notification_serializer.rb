module Api
  class ClientNotificationSerializer < ActiveModel::Serializer
    attributes :id,
        :data_type,
        :data,
        :deleted,
        :created_at

    has_one :client

    def client
      ClientSerializer.new(object.client)
    end
  end
end
