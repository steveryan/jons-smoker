class ControlsController < ApplicationController
  def overview
    desired_led = current_led = nil
    REDISLABS.pipelined do |pipeline|
      desired_led = pipeline.get("led")
      current_led = pipeline.get("current_state")
    end
    @desired_led = desired_led.value
    @current_led = current_led.value

    # get currently used memory
    mem = GetProcessMem.new
    @memory_used = mem.mb
  end

  def chart
    @chart_data = REDISLABS.get("chart")
    @chart_data = @chart_data.split(" ").map { |x| x.split(",") }.map { |x| [x[0], x[1].to_i] }
    @chart_data = @chart_data.map { |x| [DateTime.parse(x[0]).strftime("%Y-%m-%d %H:%M"), x[1]] }

    render partial: "chart", locals: { chart_data: @chart_data }
  end

  def chart_data
    @chart_data = REDISLABS.get("chart")
    @chart_data = @chart_data.split("~").map { |x| x.split(",") }.map { |x| [x[0], x[1].to_i] }
    @chart_data = @chart_data.map { |x| [DateTime.parse(x[0]).strftime("%Y-%m-%d %H:%M"), x[1]] }
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

  def edit_status
    desired_led = current_led = nil
    REDISLABS.pipelined do |pipeline|
      desired_led = pipeline.get("led")
      current_led = pipeline.get("current_state")
    end
    @desired_led = desired_led.value
    @current_led = current_led.value
    render partial: 'edit_form', locals: { desired_led: @desired_led, current_led: @current_led }
  end

  def update_status
    # TODO: Update this to check that the value is an integer between 0 and 250
    desired_led = params[:desired_led]
    REDISLABS.set("led", desired_led)

    desired_led = current_led = nil
    REDISLABS.pipelined do |pipeline|
      desired_led = pipeline.get("led")
      current_led = pipeline.get("current_state")
    end
    @desired_led = desired_led.value
    @current_led = current_led.value

    respond_to do |format|
      format.html { redirect_to root_path, notice: "Status updated successfully" }
      format.turbo_stream { 
        render turbo_stream: turbo_stream.replace(:current_status, partial: 'current_status', locals: { desired_led: @desired_led, current_led: @current_led }) 
      }
    end
  end
end
