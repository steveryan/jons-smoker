class ControlsController < ApplicationController
  def overview
    @desired_led = REDISLABS.get("led")
  end

  def chart
    @chart_data = REDISLABS.get("chart")
    @chart_data = @chart_data.split(" ").map { |x| x.split(",") }.map { |x| [x[0], x[1].to_i] }
    

    render partial: "chart", locals: { chart_data: @chart_data }
  end
end
