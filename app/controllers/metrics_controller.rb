class MetricsController < ApplicationController
  
  def index
    res = $redis.get("metrics")
    @metrics = JSON.parse(res)
    #render json: @metrics['running_processes']

  end
end
