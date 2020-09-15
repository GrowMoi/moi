module Api
  class ClientNotificationSerializer < ActiveModel::Serializer
    attributes :id,
        :data_type,
        :data,
        :deleted,
        :opened,
        :created_at,
        :type

    has_one :client

    def type
      object.data_type
    end

    def client
      ClientSerializer.new(object.client)
    end
  end
end
