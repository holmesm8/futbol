require 'minitest/autorun'
require 'minitest/pride'
require './lib/season'

class SeasonTest < Minitest::Test

  def setup
    Season.from_csv('./data/game_teams_dummy.csv')
    @season = Season.all[0]
  end

  def test_it_exists
    assert_instance_of Season, @season
  end

  def test_it_can_determine_total_home_games_played_by_team_id
    assert_equal ({6=>2, 12=>1, 10=>1, 21=>1, 53=>2, 1=>2, 24=>1, 4=>2}), Season.total_home_games_played
  end

  def test_it_can_determine_total_away_games_played_by_team_id
    assert_equal ({3=>2, 23=>2, 5=>1, 19=>1, 28=>1, 25=>1, 2=>1, 10=>1, 6=>1}), Season.total_away_games_played
  end

  def test_it_can_determine_total_home_win_percentage
    assert_equal ({6=>2, 12=>1, 10=>1, 21=>1, 53=>2, 1=>2, 24=>1, 4=>2}), Season.home_win_percentage
  end

  def test_it_can_determine_home_win_percentage
    skip
    assert_equal "sfgdfg", Season.home_win_percentage
  end

  def test_it_can_determine_best_fans
    skip
    assert_equal "sfgdfg", Season.best_fans
  end

  def test_it_can_determine_worst_fans
    skip
    assert_equal "sfgdfg", Season.worst_fans
  end

  def test_it_can_determine_winningest_team_across_all_seasons
    skip
    assert_equal "sfjghdfjhg", Game.winningest_team
  end
end
