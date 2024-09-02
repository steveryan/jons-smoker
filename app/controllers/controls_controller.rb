class ControlsController < ApplicationController
  def overview
    desired_led = current_led = nil
    REDISLABS.pipelined do |pipeline|
      desired_led = pipeline.get("led")
      current_led = pipeline.get("current_state")
    end
    @desired_led = desired_led.value
    @current_led = current_led.value
  end

  def chart
    @chart_data = REDISLABS.get("chart")
    @chart_data = @chart_data.split(" ").map { |x| x.split(",") }.map { |x| [x[0], x[1].to_i] }
    

    render partial: "chart", locals: { chart_data: @chart_data }
  end

  def chart_data
    @chart_data = REDISLABS.get("chart")
    @chart_data = @chart_data.split(" ").map { |x| x.split(",") }.map { |x| [x[0], x[1].to_i] }
    render json: @chart_data
  end

  def status
    desired_led = current_led = nil
    REDISLABS.pipelined do |pipeline|
      desired_led = pipeline.get("led")
      current_led = pipeline.get("current_state")
    end
    @desired_led = desired_led.value
    @current_led = current_led.value

    render partial: "current_status", locals: { desired_led: @desired_led, current_led: @current_led }
  end
end
