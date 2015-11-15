require './test/test_helper'

class TodayCheckerTest < ActiveSupport::TestCase
  attr_reader :service, :user

  # test '#conflict' do
  #   skip
  #   VCR.use_cassette("today#conflict") do
  #     # repos = service.repos(user)
  #     # repo = service.repos(user).first
  #     #
  #     # assert_equal 28, repos.count
  #     # assert_equal 'API-Curious', repo["name"]
  #   end
  # end
  #
  # test '#weekend!' do
  #   skip
  #   VCR.use_cassette("today#weekend!") do
  #     # followers = service.followers(user)
  #     # follower = service.followers(user).first
  #     #
  #     # assert_equal 25, followers.count
  #     # assert_equal 'Abouttabs', follower["login"]
  #   end
  # end
  #
  # test '#update_info' do
  #   skip
  #   VCR.use_cassette("today#update_info") do
  #     # organizations = service.organizations(user)
  #     # organization = service.organizations(user).first
  #     #
  #     # assert_equal 0, organizations.count
  #   end
  # end
end
