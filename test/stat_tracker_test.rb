require './test/test_helper'
require './lib/stat_tracker'

class StatTrackerTest < Minitest::Test

  def setup
    game_path = './data/games_dummy.csv'
    team_path = './data/teams.csv'
    game_teams_path = './data/game_teams_dummy.csv'

    our_locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }

   @stat_tracker = StatTracker.from_csv(our_locations)
 end

  def test_it_exists
    assert_instance_of StatTracker, @stat_tracker
  end

  def test_it_has_attributes
    assert_instance_of Array, @stat_tracker.games
    assert_instance_of Game, @stat_tracker.games[0]
    assert_instance_of Array, @stat_tracker.teams
    assert_instance_of Team, @stat_tracker.teams[0]
    assert_instance_of Array, @stat_tracker.game_teams
    assert_instance_of Season, @stat_tracker.game_teams[0]
  end

  def test_it_can_calculate_highest_total_score
    assert_equal 6, @stat_tracker.highest_total_score
  end

  def test_it_can_calculate_lowest_total_score
    assert_equal 0, @stat_tracker.lowest_total_score
  end

  def test_it_can_calculate_biggest_blowout
    assert_equal 5, @stat_tracker.biggest_blowout
  end

  def test_it_can_calculate_percentage_home_wins
    assert_equal 0.56, @stat_tracker.percentage_home_wins
  end

  def test_it_can_calculate_percentage_visitor_wins
    assert_equal 0.36, @stat_tracker.percentage_visitor_wins
  end

  def test_it_can_calculate_percentage_ties
    assert_equal 0.08, @stat_tracker.percentage_ties
  end

  def test_it_can_count_games_by_season
    assert_equal ({"20122013"=>6, "20142015"=>20, "20152016"=>2, "20172018"=>12, nil=>2, "20132014"=>6, "20162017"=>2}), @stat_tracker.count_of_games_by_season
  end

  def test_it_calculate_average_goals_per_game
    assert_equal 3.92, @stat_tracker.average_goals_per_game
  end

  def test_it_calculate_average_goals_per_season
    assert_equal ({"20122013"=>4.67, "20142015"=>3.8, "20152016"=>3.0, "20172018"=>4.42, nil=>0.0, "20132014"=>3.83, "20162017"=>5.0}), @stat_tracker.average_goals_by_season
  end

  def test_count_of_teams
    assert_equal 32, @stat_tracker.count_of_teams
  end

  def test_finds_team_with_best_offense
    assert_equal "Reign FC", @stat_tracker.best_offense
  end

  def test_finds_team_with_worst_offense
    assert_equal "North Carolina Courage", @stat_tracker.worst_offense
  end

  def test_finds_team_with_best_defense
    assert_equal "North Carolina Courage", @stat_tracker.best_defense
  end

  def test_finds_team_with_worst_defense
    assert_equal "Los Angeles FC", @stat_tracker.worst_defense
  end

  def test_finds_team_with_highest_scoring_visitor
    assert_equal "North Carolina Courage", @stat_tracker.highest_scoring_visitor
  end

  def test_finds_team_with_highest_scoring_home_team
    assert_equal "Reign FC", @stat_tracker.highest_scoring_home_team
  end

  def test_finds_team_with_lowest_scoring_home_team

    assert_equal "North Carolina Courage", @stat_tracker.lowest_scoring_home_team
  end

  def test_finds_team_with_lowest_scoring_visitor
    assert_equal "Los Angeles FC", @stat_tracker.lowest_scoring_visitor
  end

  def test_it_can_determine_winningest_team_across_all_seasons
    assert_equal "FC Dallas", @stat_tracker.winningest_team
  end

  def test_it_can_determine_best_fans
    assert_equal "LA Galaxy", @stat_tracker.best_fans
  end

  def test_it_can_determine_worst_fans
    assert_equal ["Sporting Kansas City", "Seattle Sounders FC"], @stat_tracker.worst_fans
  end

  # def test_can_find_biggest_bust
  #   assert_equal "Real Salt Lake", @stat_tracker.biggest_bust("20162017")
  # end

  def test_it_can_return_team_with_most_tackles_in_the_season
    assert_equal "Houston Dash", @stat_tracker.most_tackles("20132014")
  end

  def test_it_can_return_team_with_fewest_tackles_in_the_season
    assert_equal "Montreal Impact", @stat_tracker.fewest_tackles("20132014")
  end

  def test_it_can_return_the_winningest_coach_by_season
    assert_equal "John Tortorella", @stat_tracker.winningest_coach("20132014")
  end

  def test_it_can_return_the_worst_coach_by_season
    assert_equal "Mike Yeo", @stat_tracker.worst_coach("20132014")
  end

  def test_most_accurate_team
    assert_equal "Utah Royals FC", @stat_tracker.most_accurate_team("20132014")
  end

  def test_least_accurate_team
    assert_equal "Minnesota United FC", @stat_tracker.least_accurate_team("20132014")
  end

  def test_it_can_find_best_season
    assert_equal ("20122013"), @stat_tracker.best_season("6")
  end

  def test_it_can_find_worst_season
    assert_equal "20122013", @stat_tracker.worst_season("6")
  end

  def test_it_can_find_average_win_percentage
    assert_equal (0.8), @stat_tracker.average_win_percentage("6")
  end

  def test_it_can_calculate_most_goals_scored_by_team_id
    assert_equal 2, @stat_tracker.most_goals_scored("18")
  end

  def test_it_can_calculate_fewest_goals_scored_by_team_id
    assert_equal 0, @stat_tracker.fewest_goals_scored("18")
  end
end
