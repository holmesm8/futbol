require 'csv'
require_relative './game'

class Season < Game
  attr_reader :hoa, :result

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

  def self.biggest_bust(season)
    regular_season_win_percents = regular_season_win_percentages(season)
    postseason_win_percents = postseason_win_percentages(season)

    percentage_diff = postseason_win_percents.reduce(regular_season_win_percents) do |acc, (key, ps_win_percent)|
      acc[key] = (regular_season_win_percents[key] - postseason_win_percents[key]).round(2)
      acc
    end
    require "pry"; binding.pry

    # max = 0
    # name = ''
    # @@all_teams.each do |team|
    #   if postseason_win_percents.keys.include?(team.team_id)
    #     if postseason_win_percents[team.team_id] == 0
    #       max = regular_season_win_percents[team.team_id]
    #     elsif regular_season_win_percents[team.team_id] == 0
    #       max = postseason_win_percents[team.team_id]
    #    elsif (regular_season_win_percents[team.team_id] - postseason_win_percents[team.team_id]) > max
    #      max = (regular_season_win_percents[team.team_id] - postseason_win_percents[team.team_id]).round(2)
    #      name = team.team_name
    #    end
    #   end
    # end
    # name
  end

  def self.all_regular_season_games(season)
    @@all_games.find_all do |game|
      game if game.type == "Regular Season" && game.season == season
    end
  end

  def self.all_postseason_games(season)
    @@all_games.find_all do |game|
      game if game.type == "Postseason" && game.season == season
    end
  end

  def self.total_regular_season_games_by_team(season)
    regular_season_games = all_regular_season_games(season)
    regular_season_games.reduce({}) do |acc, game|
      if acc.keys.include?(game.home_team_id)
        acc[game.home_team_id] += 1
      else
        acc[game.home_team_id] = 1
      end

      if acc.keys.include?(game.away_team_id)
        acc[game.away_team_id] += 1
      else
        acc[game.away_team_id] = 1
      end
      acc
    end
  end

  def self.total_regular_season_wins_by_team(season)
    regular_season_games = all_regular_season_games(season)
    wins_by_team = regular_season_games.reduce({}) do |acc, game|
      winner_id = winner(game)
      loser_id = loser(game)
      if acc.keys.include?(winner_id)
        acc[winner_id] += 1
      elsif !acc.keys.include?(winner_id)
        acc[winner_id] = 1
        acc[loser_id] = 0
      end
      acc
    end
  end

  def self.regular_season_win_percentages(season)
    total_games_hash = total_regular_season_games_by_team(season)
    total_wins = total_regular_season_wins_by_team(season)

    win_percentages = total_games_hash.reduce({}) do |acc, (team_id, total_games)|
      if total_wins.keys.include?(team_id) && !acc.keys.include?(team_id)
        acc[team_id] = ((total_wins[team_id] / total_games_hash[team_id].to_f) * 100).round(2)
      elsif total_games_hash.keys.include?(team_id) && !total_wins.keys.include?(team_id)
        acc[team_id] = 0.0
      end
      acc
    end.compact
  end

  def self.total_postseason_games_by_team(season)
    postseason_games = all_postseason_games(season)
    postseason_games.reduce({}) do |acc, game|
      if acc.keys.include?(game.home_team_id)
        acc[game.home_team_id] += 1
      else
        acc[game.home_team_id] = 1
      end

      if acc.keys.include?(game.away_team_id)
        acc[game.away_team_id] += 1
      else
        acc[game.away_team_id] = 1
      end
      acc
    end
  end

  def self.total_postseason_wins_by_team(season)
    postseason_games = all_postseason_games(season)
    postseason_games.reduce({}) do |acc, game|
      winner_id = winner(game)
      loser_id = loser(game)
      if acc.keys.include?(winner_id)
        acc[winner_id] += 1
      elsif !acc.keys.include?(winner_id)
        acc[winner_id] = 1
        acc[loser_id] = 0
      end
      acc
    end
  end

  def self.postseason_win_percentages(season)
    total_games_hash = total_postseason_games_by_team(season)
    total_wins = total_postseason_wins_by_team(season)

    win_percentages = total_games_hash.reduce({}) do |acc, (team_id, total_games)|
      if total_wins.keys.include?(team_id) && !acc.keys.include?(team_id)
        acc[team_id] = ((total_wins[team_id] / total_games.to_f) * 100).round(2)
      elsif !total_games_hash.keys.include?(team_id)
        acc[team.team_id] = 0.0
      end
      acc
    end
  end

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
end
