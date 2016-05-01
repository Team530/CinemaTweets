require 'test_helper'

class KeywordMovieAnalysisControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
