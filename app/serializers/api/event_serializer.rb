# == Schema Information
#
# Table name: events
#
#  id           :integer          not null, primary key
#  title        :string           not null
#  description  :string
#  image        :string
#  content_ids  :text             default([]), is an Array
#  publish_days :text             default([]), is an Array
#  duration     :integer          not null
#  kind         :string
#  user_level   :integer          default(1)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
module Api
  class EventSerializer < ActiveModel::Serializer
    attributes :id,
               :title,
               :description,
               :image,
               :contents,
               :duration,
               :kind,
               :user_level,
               :is_available,
               :completed

    def image
      image = object.image
      image ? image.url : ''
    end

    def contents
      ids = object.content_ids.map.reject { |id| id.empty? }
      branches_neurons_ids = get_neurons_id_by_branch
      ids.map do |id|
        content = Content.find(id)
        neuron = content.neuron
        root_neuron = TreeService::RootFetcher.root_neuron
        color = nil
        # binding.pry
        unless (branches_neurons_ids[:language][:ids] & [neuron.id]).empty?
          color = branches_neurons_ids[:language][:color]
        end
        unless (branches_neurons_ids[:art][:ids] & [neuron.id]).empty?
          color = branches_neurons_ids[:art][:color]
        end
        unless (branches_neurons_ids[:learn][:ids] & [neuron.id]).empty?
          color = branches_neurons_ids[:learn][:color]
        end
        unless (branches_neurons_ids[:nature][:ids] & [neuron.id]).empty?
          color = branches_neurons_ids[:nature][:color]
        end
        {
          content_id: id,
          neuron: neuron.title,
          color: root_neuron.id == neuron.id ? 'yellow' : color
        }
      end
    end

    def is_available
      !current_user.user_events.find_by_event_id(object.id)
    end

    def completed
      event_user = current_user.user_events.find_by_event_id(object.id)
      event_user ? event_user.completed : false
    end

    def get_neurons_id_by_branch
      branches = {
        language: {
          name: 'Lenguaje',
          color: 'yellow',
          ids: []
        },
        art: {
          name: 'Artes',
          color: 'red',
          ids: []
        },
        learn: {
          name: 'Aprender',
          color: 'blue',
          ids: []
        },
        nature: {
          name: 'Naturaleza',
          color: 'green',
          ids: []
        }
      }
      branches.each do |key, value|
        branch = value[:name].downcase
        neuron_branch = Neuron.where('lower(title) = ?', branch).first
        branch_ids = TreeService::RecursiveChildrenIdsFetcher.new(
          neuron_branch
        ).children_ids
        branch_ids = branch_ids << neuron_branch.id
        value[:ids] = branch_ids
      end
      branches
    end


    alias_method :current_user, :scope
  end
end
