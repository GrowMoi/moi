class PublicLeaderboardService
  def initialize(params:)
    @params = params
    set_params_sorting_options!
  end

  def all_leaders
    Leaderboard
      .joins(:user)
      .order(sorting_options)
  end

  private

  def set_params_sorting_options!
    @params_sorting_options = []
    case @params[:sort_by]
    when "school"
      @params_sorting_options << User.arel_table[:school].asc
    when "city"
      @params_sorting_options << User.arel_table[:city].asc
    when "age"
      @params_sorting_options << User.arel_table[:age].asc
    end
  end

  def sorting_options
    @params_sorting_options.concat([
      Leaderboard.arel_table[:contents_learnt].desc,
      Leaderboard.arel_table[:time_elapsed].asc
    ])
  end
end
