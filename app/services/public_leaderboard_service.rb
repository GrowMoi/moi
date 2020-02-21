class PublicLeaderboardService
  def initialize(params:)
    @params = params
    set_params_sorting_options!
    set_params_query_options!
  end

  def all_leaders
    main_scope = Leaderboard.joins(:user).order(sorting_options)
    if @params_query_options.present?
      main_scope = main_scope.where(@params_query_options)
    end
    main_scope
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
      @params_sorting_options << User.arel_table[:birth_year].asc
    end
  end

  def set_params_query_options!
    @params_query_options = {}
    user_query_params_options = [ :school, :city, :age ]
    user_query_params_options.each do |query_opt|
      if @params[query_opt].present?
        if query_opt == "age".to_sym
          @params_query_options[:"users.birth_year"] = Time.now.year - @params[query_opt].to_i
        else
          @params_query_options[:"users.#{query_opt}"] = @params[query_opt]
        end
      end
    end
  end

  def sorting_options
    @params_sorting_options.concat([
      Leaderboard.arel_table[:contents_learnt].desc,
      Leaderboard.arel_table[:time_elapsed].asc
    ])
  end
end
