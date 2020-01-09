require './test/test_helper'
require './lib/game'
require './lib/team'
require 'mocha/minitest'

class GameTest < Minitest::Test

  def setup
    Game.from_csv('./data/games_dummy.csv')
    @game = Game.all[0]

    Team.from_csv('./data/teams.csv')
    @team = Team.all[0]
  end

  def test_it_exists
    assert_instance_of Game, @game
  end

  def test_it_has_attributes
    assert_equal "2012030221", @game.game_id
    assert_equal "20122013", @game.season
    assert_equal "Postseason", @game.type
    assert_equal "5/16/13", @game.date_time
    assert_equal 3, @game.away_team_id
    assert_equal 6, @game.home_team_id
    assert_equal 2, @game.away_goals
    assert_equal 3, @game.home_goals
    assert_equal "Toyota Stadium", @game.venue
  end

  def test_it_can_calculate_highest_total_score
    assert_equal 6, Game.highest_total_score
  end

  def test_it_can_calculate_lowest_total_score
    assert_equal 0, Game.lowest_total_score
  end

  def test_it_can_calculate_biggest_blowout
    assert_equal 5, Game.biggest_blowout
  end

  def test_it_can_calculate_percentage_home_wins
    assert_equal 0.56, Game.percentage_home_wins
  end

  def test_it_can_calculate_percentage_visitor_wins
    assert_equal 0.36, Game.percentage_visitor_wins
  end

  def test_it_can_calculate_percentage_ties
    assert_equal 0.08, Game.percentage_ties
  end

  def test_it_can_count_games_by_season
    assert_equal ({"20122013"=>6, "20142015"=>20, "20152016"=>2, "20172018"=>12, nil=>2, "20132014"=>6, "20162017"=>2}), Game.count_of_games_by_season
  end

  def test_it_calculate_average_goals_per_game
    assert_equal 3.92, Game.average_goals_per_game
  end

  def test_it_calculate_average_goals_per_season
    assert_equal ({"20122013"=>4.67, "20142015"=>3.8, "20152016"=>3.0, "20172018"=>4.42, nil=>0.0, "20132014"=>3.83, "20162017"=>5.0}), Game.average_goals_by_season
  end

  def test_count_of_teams
    assert_equal 32, Game.count_of_teams
  end

  def test_finds_team_with_best_offense
    assert_equal "Reign FC", Game.best_offense
  end

  def test_finds_team_with_worst_offense
    assert_equal "North Carolina Courage", Game.worst_offense
  end

  def test_finds_team_with_best_defense
    assert_equal "North Carolina Courage", Game.best_defense
  end

  def test_finds_team_with_worst_defense
    assert_equal "Los Angeles FC", Game.worst_defense
  end

  def test_finds_team_with_highest_scoring_visitor
    assert_equal "North Carolina Courage", Game.highest_scoring_visitor
  end

  def test_finds_team_with_highest_scoring_home_team
    assert_equal "Reign FC", Game.highest_scoring_home_team
  end

  def test_finds_team_with_lowest_scoring_home_team
    assert_equal "North Carolina Courage", Game.lowest_scoring_home_team
  end

  def test_finds_team_with_lowest_scoring_visitor
    assert_equal "Los Angeles FC", Game.lowest_scoring_visitor
  end

  def test_it_can_determine_winner_team_id
    assert_equal 6, Game.winner(@game)
  end
end
