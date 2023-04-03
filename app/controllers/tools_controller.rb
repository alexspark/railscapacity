class ToolsController < ApplicationController
  def calculator
    @form = Calculator.new(calculator_params)
    @form.submit unless calculator_params.empty?
  end

  def calculate
    @form = Calculator.new(calculator_params)
    @form.submit

    redirect_to root_path calculator: calculator_params
  end

  private

  # workers = rps * avg response time
  # utilization rate
  # number of workers per cpu
  # ram per process
  def calculator_params
    params.fetch(:calculator, {})
      .permit(
    :total_requests,
    :request_scale,
    :average_response_time_in_ms,
    :util_pct,
    :number_of_workers_per_cpu,
    :memory_per_process,
    :memory_per_process_units
    )
  end

end
