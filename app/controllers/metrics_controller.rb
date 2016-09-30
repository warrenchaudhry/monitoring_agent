class MetricsController < ApplicationController

  def index
    res = $redis.get("metrics")
    @metrics = JSON.parse(res) rescue nil
  end
end
