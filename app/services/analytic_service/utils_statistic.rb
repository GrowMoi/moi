module AnalyticService
  class UtilsStatistic

    def initialize(user, statistics)
      @user = user
      @statistics = statistics
    end

    def total_right_questions
      count = 0
      if @statistics["user_tests"]
        tests = @statistics["user_tests"][:value]
      else
        tests = AnalyticService::TestStatistic.new(@user).results
      end
      tests.each do |test|
        test[:questions].each do |question|
          if question[:correct] === true
            count = count + 1
          end
        end
      end
      count
    end

    def group_by_neuron
      contents = joins_neuron_content_learnings
      contents.group_by{|i| i.neuron_id}.map do |k,v|
        {
          id: k,
          title: v.first[:title],
          contents_learnt: v.size,
          parent_id: v.first[:parent_id]
        }
      end
    end

    def joins_neuron_content_learnings
      ContentLearning.joins("LEFT OUTER JOIN neurons ON content_learnings.neuron_id = neurons.id")
                    .where(user:@user)
                    .select(:id, :content_id, :neuron_id, :'neurons.title', :'neurons.parent_id')
    end

    def format_donut_chart_data
      @items_content = group_by_neuron
      format_data
    end

    def format_data
      @contents_count = 0
      root_neuron = @items_content.detect {|i|i[:parent_id] == nil}
      @root_children = @items_content.find_all {|i|i[:parent_id] == root_neuron[:id]}
      @items_content.delete_if {|i|i[:id] == root_neuron[:id] || i[:parent_id] == root_neuron[:id]}
      extract_contents_by_branch(@root_children)
      @root_children
    end

    def extract_contents_by_branch(new_children)
      new_children.each do |child|
        count = 0
        @children = []
        compute_contents_by_branch(child, @items_content, count)
        if @root_children.include?(child)
          child[:total_contents_learnt] = child[:contents_learnt] + @contents_count
          child.delete(:contents_learnt)
          @contents_count = 0
        end
      end
    end

    def compute_contents_by_branch(root_item, items, count)
      current_item = items[count]
      if current_item.nil?
        callback_extract_contents
      else
        callback_compute_contents(current_item, root_item, items, count)
      end
    end

    def callback_extract_contents
      if @children.size > 0
        extract_contents_by_branch(@children)
      else
        return
      end
    end

    def callback_compute_contents(current_item, root_item, items, count)
      if current_item[:parent_id] == root_item[:id]
        child = items.slice!(count)
        @children.push(child)
        @contents_count = @contents_count + child[:contents_learnt]
        compute_contents_by_branch(root_item, items, count)
      else
        count = count + 1
        compute_contents_by_branch(root_item, items, count)
      end
    end
  end
end
