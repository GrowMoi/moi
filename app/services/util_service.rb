class UtilService
  def initialize(client)
    @client = client
  end

  def generate_elapsed_time
    user_content_learnings = ContentLearning.where(user: @client).order(created_at: :desc)
    time_elapsed = 0
    if user_content_learnings.present?
      last_content_learnt = user_content_learnings.first
      time_diff = last_content_learnt.created_at - @client.created_at
      milliseconds = (time_diff.to_f.round(3)*1000).to_i
      time_elapsed = milliseconds
    end
    time_elapsed
  end
end
