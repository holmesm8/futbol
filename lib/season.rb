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

  def biggest_bust
    # return the name of the team
    # regular - post (win percetages)
    # max
    name = ''
  end

end
