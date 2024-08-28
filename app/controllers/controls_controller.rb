class ControlsController < ApplicationController
  def overview
    @desired_led = REDISLABS.get("led")
    @chart_data = REDISLABS.get("chart")
  end

  def chart
    @chart_data = REDISLABS.get("chart")
    @chart_data = @chart_data.split(" ")
    @chart_data = @chart_data.map { |x| x.split(",") }
    @chart_data = @chart_data.map { |x| [x[0], x[1].to_i] }
    p @chart_data
    render partial: "chart", locals: { chart_data: @chart_data }
  end
end
