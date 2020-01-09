require './test/test_helper'
require './lib/game'
require './lib/team'
require './lib/season'
require 'pry'

class GamesTest < Minitest::Test

  def setup
    Game.from_csv('./data/games_dummy.csv')
    @game = Game.all[0]

    Team.from_csv('./data/teams.csv')
    @team = Team.all[0]
  end

  def test_it_exists
    assert_instance_of Game, @game
  end
end
