require 'minitest/autorun'
require 'minitest/pride'
require './lib/team'

class TeamTest < Minitest::Test

  def setup
    Team.from_csv('./data/teams.csv')
    @team = Team.all[0]
  end

  def test_it_exists
    assert_instance_of Team, @team
  end
end
