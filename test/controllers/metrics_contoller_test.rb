require 'test_helper'

class MetricsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @report = Monitoring::Report.new
    @metrics = @report.get_metrics
  end

  test "should get index" do
    get metrics_url
    assert_response :success
  end


end
