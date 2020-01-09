require 'csv'
require_relative './game'
require_relative './team'
require 'pry'

class Season < Game

  attr_reader :game_id, :team_id, :hoa, :result, :settled_in, :head_coach, :shots, :goals, :tackles

  @@all_seasons = []

  def self.all
    @@all_seasons
  end

  def self.from_csv(file_path)
    csv = CSV.read("#{file_path}", headers: true, header_converters: :symbol)

    @@all_seasons = csv.map {|row| Season.new(row)}
  end

  def initialize(league_info)
    @game_id = league_info[:game_id]
    @team_id = league_info[:team_id].to_i
    @hoa = league_info[:hoa]
    @result = league_info[:result]
    @settled_in = league_info[:settled_in]
    @head_coach = league_info[:head_coach]
    @shots = league_info[:shots].to_i
    @goals = league_info[:goals].to_i
    @tackles = league_info[:tackles].to_i
    @pim = league_info[:pim].to_i
    @power_play_opportunities = league_info[:powerplayopportunities].to_i
    @power_play_goals = league_info[:powerplaygoals].to_i
    @face_off_win_percentage = league_info[:faceoffwinpercentage].to_i
    @giveaways = league_info[:giveaways].to_i
    @takeaways = league_info[:takeaways].to_i
  end

  def self.total_home_games_played
    total_home_games = @@all_seasons.reduce({}) do |acc, season|
      if acc.keys.include?(season.team_id) && season.hoa == "home"
        acc[season.team_id] += 1
      elsif season.hoa == "home"
        acc[season.team_id] = 1
      end
      acc
    end
  end

  def self.total_away_games_played
    total_away_games = @@all_seasons.reduce({}) do |acc, season|
      if acc.keys.include?(season.team_id) && season.hoa == "away"
        acc[season.team_id] += 1
      elsif season.hoa == "away"
        acc[season.team_id] = 1
      end
      acc
    end
  end

  def self.total_home_wins_by_team
    testy = @@all_seasons.reduce({}) do |acc, season|
      if acc.keys.include?(season.team_id) && (season.hoa == "home" && season.result == "WIN")
        acc[season.team_id] += 1
      elsif (season.hoa == "home" && season.result == "WIN")
        acc[season.team_id] = 1
      end
      acc
    end
  end

  def self.total_away_wins_by_team
    testy = @@all_seasons.reduce({}) do |acc, season|
      if acc.keys.include?(season.team_id) && (season.hoa == "away" && season.result == "WIN")
        acc[season.team_id] += 1
      elsif (season.hoa == "away" && season.result == "WIN")
        acc[season.team_id] = 1
      end
      acc
    end
  end

  def self.home_win_percentages
    home_wins = total_home_wins_by_team
    num_home_games = total_home_games_played

    percentages = @@all_seasons.reduce({}) do |acc, season|
      if home_wins.keys.include?(season.team_id) && !acc.keys.include?(season.team_id)
        acc[season.team_id] = ((home_wins[season.team_id] / num_home_games[season.team_id].to_f) * 100).round(2)
      end
      acc
    end
  end

  def self.away_win_percentages
    away_wins = total_away_wins_by_team
    num_away_games = total_away_games_played

    percentages = @@all_seasons.reduce({}) do |acc, season|
      if away_wins.keys.include?(season.team_id) && !acc.keys.include?(season.team_id)
        acc[season.team_id] = ((away_wins[season.team_id] / num_away_games[season.team_id].to_f) * 100).round(2)
      end
      acc
    end
  end

  def self.winningest_team
    win_percentages = home_win_percentages

    first_highest_percentage = win_percentages.find do |team_id_percentage|
      team_id_percentage if win_percentages.values.max == win_percentages[team_id_percentage.first]
    end

    name = ''
    @@all_teams.each do |team|
      if first_highest_percentage.first == team.team_id
        name = team.team_name
      end
    end
    name
  end

  def self.best_fans
    home_percentages = home_win_percentages
    away_percentages = away_win_percentages

    max = 0.0
    name = ''
    @@all_teams.each do |team|
       if away_percentages.keys.include?(team.team_id) && home_percentages.keys.include?(team.team_id)
        if (home_percentages[team.team_id] - away_percentages[team.team_id]) > max
          max = (home_percentages[team.team_id] - away_percentages[team.team_id])
          name = team.team_name
        end
       end
    end
    name
  end

  def self.worst_fans
    away_percentages = away_win_percentages
    home_percentages = home_win_percentages

    team_names = []
    @@all_teams.each do |team|
      if away_percentages.keys.include?(team.team_id) && home_percentages.keys.include?(team.team_id)
        if away_percentages[team.team_id] > home_percentages[team.team_id]
          team_names << team.team_name
        end
      end
    end
    team_names
  end

  # def self.biggest_bust(season)
  #   seasons = seasons_filter(season)
  #   games = @@all_games.find_all {|game| game if game.season == season}
  #
  #   games_by_season.map do |season|
  #
  #   end
  # end

  def self.winner(game_object)
    if game_object.home_goals > game_object.away_goals
      game_object.home_team_id
    elsif game_object.home_goals < game_object.away_goals
      game_object.away_team_id
    end
  end

  def self.loser(game_object)
    if game_object.home_goals > game_object.away_goals
      game_object.away_team_id
    elsif game_object.home_goals < game_object.away_goals
      game_object.home_team_id
    end
  end

  def self.seasons_filter(season_id)
    season_filter = @@all_seasons.find_all do |season|
      season if season_id.slice(0..3) == season.game_id.slice(0..3)
    end
  end

  def self.most_tackles(season_id)
    seasons_by_season = seasons_filter(season_id)
    team_tackles = seasons_by_season.reduce(Hash.new(0)) do |result, season|
      result[season.team_id] += season.tackles
      result
    end
    id_stat = team_tackles.max_by {|k, v| v}
    find_team_name(id_stat.first)
  end

  def self.fewest_tackles(season_id)
    seasons_by_season = seasons_filter(season_id)
    team_tackles = seasons_by_season.reduce(Hash.new(0)) do |result, season|
      result[season.team_id] += season.tackles
      result
    end
    id_stat = team_tackles.min_by {|k, v| v}
    find_team_name(id_stat.first)
  end

  def self.winningest_coach(season_id)
    seasons_by_season = seasons_filter(season_id)
    coach_wins = seasons_by_season.reduce(Hash.new(0)) do |result, season|
      result[season.head_coach] += 1 if season.result == "WIN"
      result
    end
    coach_total_games = seasons_by_season.reduce(Hash.new(0)) do |result, season|
      result[season.head_coach] += 1
      result
    end
    coach_percentage = coach_total_games.reduce(coach_wins) do |result, (coach, total_games)|
      result[coach] = ((result[coach] / total_games.to_f) * 100).round(2)
      result
    end
    coach = coach_percentage.max_by {|k, v| v}
    coach[0]
  end

  def self.worst_coach(season_id)
    seasons_by_season = seasons_filter(season_id)
    coach_wins = seasons_by_season.reduce(Hash.new(0)) do |result, season|
      result[season.head_coach] += 1 if season.result == "WIN"
      result
    end
    coach_total_games = seasons_by_season.reduce(Hash.new(0)) do |result, season|
      result[season.head_coach] += 1
      result
    end
    coach_percentage = coach_total_games.reduce(coach_wins) do |result, (coach, total_games)|
      result[coach] = ((result[coach] / total_games.to_f) * 100).round(2)
      result
    end
    coach = coach_percentage.min_by {|k, v| v}
    coach[0]
  end

  def self.most_accurate_team(season_id)	#Name of the Team with the best ratio of shots to goals for the season	String
    ratio_per_game_hash = shot_to_goal_ratio_per_game(season_id)
    team_accuracy_average_hash = average_shots_per_goal_by_team(ratio_per_game_hash)
    max_value_team(team_accuracy_average_hash)
  end

  def self.least_accurate_team(season_id)	#Name of the Team with the best ratio of shots to goals for the season	String
    ratio_per_game_hash = shot_to_goal_ratio_per_game(season_id)
    team_accuracy_average_hash = average_shots_per_goal_by_team(ratio_per_game_hash)
    min_value_team(team_accuracy_average_hash)
  end

  def self.shot_to_goal_ratio_per_game(season_id)
    game_team_objects_array_by_season = seasons_filter(season_id)
    game_team_objects_array_by_season.reduce (Hash.new([])) do |acc, season|
      if season.shots == 0
        acc[season.team_id] = 0
      elsif acc.keys.include?(season.team_id)
        acc[season.team_id] << (season.goals/season.shots.to_f).round(2)
      elsif !acc.keys.include?(season.team_id) && acc[season.team_id] != 0
        acc[season.team_id] = [(season.goals/season.shots.to_f).round(2)]
      end
      acc
    end.compact
  end

  def self.average_shots_per_goal_by_team(ratio_per_game_hash)
    ratio_per_game_hash.each do |key, value|
      ratio_per_game_hash[key] = (value.sum / value.count.to_f).round(2)
    end
  end

  def self.max_value_team(team_accuracy_average_hash)
    team_id_2 = team_accuracy_average_hash.max_by {|k, v| v}
    find_team_name(team_id_2.first)
  end

  def self.min_value_team(team_accuracy_average_hash)
    team_id_3 = team_accuracy_average_hash.min_by {|k, v| v}
    find_team_name(team_id_3.first)
  end

  def self.find_team_name(id)
    @@all_teams.find do |team|
      return team.team_name if team.team_id == id
    end
  end

  def self.best_season(team_id)
    team_id_filter = @@all_seasons.find_all {|season| season if season.team_id == team_id.to_i}
    season_count = team_id_filter.count
    total_wins = team_id_filter.reduce(Hash.new(0)) do |acc, season|
      acc[season.game_id.slice(0..3)] += 1 if season.result == "WIN"
      acc
    end
    win_percentage = total_wins.reduce(Hash.new(0)) do |acc, (key, value)|
      acc[key] = value / season_count.to_f
      acc
    end
    season_max = win_percentage.max_by {|k, v| v}
    season_max[0] + (season_max[0].to_i + 1).to_s
  end

  def self.worst_season(team_id)
    team_id_filter = @@all_seasons.find_all {|season| season if season.team_id == team_id.to_i}
    season_count = team_id_filter.count
    total_wins = team_id_filter.reduce(Hash.new(0)) do |acc, season|
      acc[season.game_id.slice(0..3)] += 1 if season.result == "WIN"
      acc
    end
    win_percentage = total_wins.reduce(Hash.new(0)) do |acc, (key, value)|
      acc[key] = value / season_count.to_f
      acc
    end
    season_max = win_percentage.min_by {|k, v| v}
    season_max[0] + (season_max[0].to_i + 1).to_s
  end

  def self.average_win_percentage(team_id)
    team_id_filter = @@all_seasons.find_all {|season| season if season.team_id == team_id.to_i}
    season_count = team_id_filter.count
    total_wins = team_id_filter.count do |season|
      season if season.result == "WIN"
    end
    (total_wins / season_count.to_f).round(2)
  end

  # def self.win_percentage_by_season(hash)
  #   hash.reduce (Hash.new(0)) do |acc, (season, result_array)|
  #     acc[season] = ((result_array.sum / result_array.count.to_f).round(2))
  #     acc
  #   end
  # end

  def self.biggest_team_blowout(team_id)
    hoa_and_game_ids_for_wins = winning_game_id_and_score_by_team (team_id)
    ids_and_scores = difference_between_scores(hoa_and_game_ids_for_wins)
    (ids_and_scores.max_by {|k, v| v})[1]
  end

  def self.winning_game_id_and_score_by_team(team_id)
    @@all_seasons.reduce (Hash.new()) do |acc, game|
      if (game.team_id == team_id && game.result == "WIN") && !acc.keys.include?(game.game_id)
        acc[game.game_id] = game.hoa
      elsif (game.team_id == team_id && game.result == "WIN") && (acc.keys.include?(game.game_id))
        acc[game.game_id] << [game.hoa]
      end
      acc
    end
  end

  def self.difference_between_scores(hash)
    @@all_games.reduce ({}) do |acc, game|
      if hash.keys.include?(game.game_id) && hash[game.game_id] == "home"
        acc[game.away_team_id] = (game.home_goals - game.away_goals).abs
      elsif hash.keys.include?(game.game_id) && hash[game.game_id] == "away"
          acc[game.home_team_id] = (game.home_goals - game.away_goals).abs
      end
      acc
    end
  end

  def self.worst_loss(team_id)
    hoa_and_game_ids_for_losses = losing_game_id_and_score_by_team (team_id)
    ids_and_scores = difference_between_scores(hoa_and_game_ids_for_losses)
    (ids_and_scores.min_by {|k, v| v})[1]
  end

  def self.losing_game_id_and_score_by_team(team_id)
    @@all_seasons.reduce (Hash.new()) do |acc, game|
      if (game.team_id == team_id && game.result == "LOSS") && !acc.keys.include?(game.game_id)
        acc[game.game_id] = game.hoa
      elsif (game.team_id == team_id && game.result == "LOSS") && (acc.keys.include?(game.game_id))
        acc[game.game_id] << [game.hoa]
      end
      acc
    end
  end

  def self.all_games_by_team_id(id)
    @@all_seasons.find_all do |season|
      season if id.to_i == season.team_id
    end
  end

  def self.most_goals_scored(id)
    games_by_team = all_games_by_team_id(id)
    counter = 0
    games_by_team.each do |game|
      counter = game.goals if game.goals > counter
    end
    counter
  end

  def self.fewest_goals_scored(id)
    games_by_team = all_games_by_team_id(id)
    counter = 100
    games_by_team.each do |game|
      counter = game.goals if game.goals < counter
    end
    counter
  end

  # def self.favorite_opponent(team_id)
  #   # Name of who they win against the most
  #   games = @@all_games.find_all do |game|
  #     game if (game.home_team_id == team_id || game.away_team_id == team_id)
  #   end
  #
  #   team_id_seasons = @@all_seasons.find_all do |season|
  #     season if (season.team_id.to_s == team_id)
  #   end
  #   # require "pry"; binding.pry
  #
  #   game_ids = team_id_seasons.map do |season|
  #     season.game_id
  #   end.uniq
  #
  #   game_ids.reduce(Hash.new(0)) do |acc, game_id|
  #
  #     acc
  #   end
  #   # games = all_games_by_team_id(team_id)
  #   # games.find_all do |game|
  #   #   game if game.game_id == games
  #   #
  #   # testy = games.reduce(Hash.new(0)) do |acc, game|
  #   #
  #   # end
  #   # [oppenent_id, games won, total games played against this team]
  #   # {team_id: {oppenent_id: .4, ...........}}
  # end

  # def coach_wins
  #   seasons_by_season.reduce(Hash.new(0)) do |result, season|
  #     result[season.head_coach] += 1 if season.result == "WIN"
  #     result
  #   end
  # end
  #
  # def coach_total_games
  #   coach_total_games = seasons_by_season.reduce(Hash.new(0)) do |result, season|
  #     result[season.head_coach] += 1
  #     result
  #   end
  # end
end


# def self.biggest_bust(season)
#   regular_season_percents = regular_season_win_percentages(season)
#   postseason_percents = postseason_win_percentages(season)
#
#   percentage_diff = postseason_percents.reduce({}) do |acc, (ps_id, ps_percent)|
#     acc[ps_id] = (ps_percent - regular_season_percents[ps_id])
#     acc
#   end
#
#   max_percent = percentage_diff.values.min
#   name = find_team_name(percentage_diff.key(max_percent))
# end
#
# def self.all_regular_season_games(season)
#   @@all_games.find_all do |game|
#     game if game.type == "Regular Season" && game.season == season
#   end
# end
#
# def self.all_postseason_games(season)
#   @@all_games.find_all do |game|
#     game if game.type == "Postseason" && game.season == season
#   end
# end
#
# def self.total_regular_season_games_by_team(season)
#   regular_season_games = all_regular_season_games(season)
#   regular_season_games.reduce({}) do |acc, game|
#     if acc.keys.include?(game.home_team_id)
#       acc[game.home_team_id] += 1
#     else
#       acc[game.home_team_id] = 1
#     end
#
#     if acc.keys.include?(game.away_team_id)
#       acc[game.away_team_id] += 1
#     else
#       acc[game.away_team_id] = 1
#     end
#     acc
#   end
# end
#
# def self.total_regular_season_wins_by_team(season)
#   regular_season_games = all_regular_season_games(season)
#
#   hsh = Hash.new(0)
#   require "pry"; binding.pry
#   regular_season_games.each do |game|
#     winner_id = winner(game)
#     next if winner_id == nil
#     hsh[winner_id] += 1
#   end
#   hsh
# end
#
# def self.regular_season_win_percentages(season)
#   total_games_hash = total_regular_season_games_by_team(season)
#   total_wins = total_regular_season_wins_by_team(season)
#
#   win_percentages = total_games_hash.reduce({}) do |acc, (team_id, total_games)|
#     if total_games_hash.keys.include?(team_id) && total_wins[team_id] == 0
#       acc[team_id] = 0.0
#     elsif
#       acc[team_id] = ((total_wins[team_id] / total_games_hash[team_id].to_f))
#     end
#     acc
#   end.compact
# end
#
# def self.total_postseason_games_by_team(season)
#   postseason_games = all_postseason_games(season)
#   regular_season_games = all_regular_season_games(season)
#
#   post_games = postseason_games.reduce({}) do |acc, game|
#     if acc.keys.include?(game.home_team_id)
#       acc[game.home_team_id] += 1
#     else
#       acc[game.home_team_id] = 1
#     end
#
#     if acc.keys.include?(game.away_team_id)
#       acc[game.away_team_id] += 1
#     else
#       acc[game.away_team_id] = 1
#     end
#     acc
#   end
#
#   regular_season_games.each do |game|
#     if !post_games.keys.include?(game.home_team_id)
#       post_games[game.home_team_id] = 0
#     elsif !post_games.keys.include?(game.away_team_id)
#       post_games[game.away_team_id] = 0
#     end
#   end
#   post_games
# end
#
# def self.total_postseason_wins_by_team(season)
#   postseason_games = all_postseason_games(season)
#
#   postseason_games.reduce({}) do |acc, game|
#     winner_id = winner(game)
#     loser_id = loser(game)
#     if acc.keys.include?(winner_id)
#       acc[winner_id] += 1
#     elsif !acc.keys.include?(winner_id)
#       acc[winner_id] = 1
#       acc[loser_id] = 0
#     end
#     acc
#   end
# end
#
# def self.postseason_win_percentages(season)
#   total_games_hash = total_postseason_games_by_team(season)
#   total_wins = total_postseason_wins_by_team(season)
#
#   win_percentages = total_games_hash.reduce({}) do |acc, (team_id, total_games)|
#     if total_games_hash[team_id] == 0
#       acc[team_id] = 0.0
#     elsif total_wins.keys.include?(team_id) && !acc.keys.include?(team_id)
#       acc[team_id] = ((total_wins[team_id] / total_games.to_f)).round(2)
#     # elsif !total_games_hash.keys.include?(team_id)
#     #   acc[team.team_id] = 0.0
#     end
#     acc
#   end
# end
