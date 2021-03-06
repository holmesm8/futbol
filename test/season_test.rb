require 'minitest/autorun'
require 'minitest/pride'
require './lib/season'

class SeasonTest < Minitest::Test

  def setup
    Game.from_csv('./data/games.csv')
    @game = Game.all[0]

    Team.from_csv('./data/teams.csv')
    @team = Team.all[0]

    Season.from_csv('./data/game_teams_dummy.csv')
    @season = Season.all[0]
  end

  def test_it_exists
    assert_instance_of Season, @season
  end

  def test_it_can_determine_total_home_games_played_by_team_id
    expected = {6=>4, 12=>1, 10=>3, 21=>3, 53=>2, 1=>4, 24=>1, 4=>3, 23=>1,
                  17=>1, 14=>1, 2=>5, 28=>1, 5=>2, 9=>2, 25=>1, 18=>2, 22=>1,
                  20=>1, 13=>2}

    assert_equal expected, Season.total_home_games_played
  end

  def test_it_can_determine_total_away_games_played_by_team_id
    expected = ({3=>2, 23=>2, 5=>2, 19=>2, 28=>3, 25=>1, 2=>1, 10=>3, 6=>1,
                  13=>4, 22=>2, 30=>1, 7=>2, 1=>1, 9=>2, 4=>2, 52=>2, 20=>1,
                  29=>2, 17=>2, 27=>1})

    assert_equal expected, Season.total_away_games_played
  end

  def test_it_can_find_total_home_wins
    expected = {6=>4, 12=>1, 10=>2, 53=>1, 23=>1, 17=>1, 2=>3, 28=>1, 5=>1,
                  21=>1, 9=>1, 25=>1, 1=>2, 13=>2}

    assert_equal expected, Season.total_home_wins_by_team
  end

  def test_it_can_find_total_away_wins
    expected = {5=>2, 28=>3, 25=>1, 23=>1, 2=>1, 7=>2, 17=>1, 10=>1, 29=>1}

    assert_equal expected, Season.total_away_wins_by_team
  end

  def test_it_can_determine_home_win_percentages
    expected = {6=>100.0, 12=>100.0, 23=>100.0, 10=>66.67, 5=>50.0, 21=>33.33,
                  53=>50.0, 28=>100.0, 1=>50.0, 25=>100.0, 2=>60.0, 13=>100.0,
                  17=>100.0, 9=>50.0}

    assert_equal expected, Season.home_win_percentages
  end

  def test_it_can_determine_away_win_percentages
    expected = {23=>50.0, 10=>33.33, 5=>100.0, 28=>100.0, 25=>100.0, 2=>100.0,
                  17=>50.0, 7=>100.0, 29=>50.0}

    assert_equal expected, Season.away_win_percentages
  end

  def test_it_can_determine_winningest_team_across_all_seasons
    assert_equal "FC Dallas", Season.winningest_team
  end

  def test_it_can_sort_by_season
    season = Season.seasons_filter("20132014")
    assert_instance_of Season, season[0]
  end

  def test_it_can_determine_best_fans
    assert_equal "LA Galaxy", Season.best_fans
  end

  def test_it_can_determine_worst_fans
    assert_equal ["Sporting Kansas City", "Seattle Sounders FC"], Season.worst_fans
  end

  def test_it_can_return_team_with_most_tackles_in_the_season
    assert_equal "Houston Dash", Season.most_tackles("20132014")
  end

  def test_it_can_return_team_with_fewest_tackles_in_the_season
    assert_equal "Montreal Impact", Season.fewest_tackles("20132014")
  end

  def test_it_can_return_the_winningest_coach_by_season
    assert_equal "John Tortorella", Season.winningest_coach("20132014")
  end

  def test_it_can_return_the_worst_coach_by_season
    assert_equal "Mike Yeo", Season.worst_coach("20132014")
  end

  def test_most_accurate_team
    assert_equal "Utah Royals FC", Season.most_accurate_team("20132014")
  end

  def test_least_accurate_team
    assert_equal "Minnesota United FC", Season.least_accurate_team("20132014")
  end

  def test_it_can_find_best_season
    assert_equal ("20122013"), Season.best_season("6")
  end

  def test_it_can_find_worst_season
    assert_equal "20122013", Season.worst_season("6")
  end

  def test_it_can_find_average_win_percentage
    assert_equal (0.8), Season.average_win_percentage("6")
  end

  def test_it_can_find_the_difference_between_scores
    hash = {"2012030221"=>"away", "2012030222"=>"away"}
    assert_equal ({6=>1}), Season.difference_between_scores(hash)
  end
  
  def test_it_can_calculate_most_goals_scored_by_team_id
    assert_equal 2, Season.most_goals_scored("18")
  end

  def test_it_can_calculate_fewest_goals_scored_by_team_id
    assert_equal 0, Season.fewest_goals_scored("18")
  end

  def test_can_find_winner
    assert_equal 6, Season.winner(@game)
  end

  def test_can_find_loser
    assert_equal 3, Season.loser(@game)
  end
end
