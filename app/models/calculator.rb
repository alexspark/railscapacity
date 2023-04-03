class Calculator
  include ActiveModel::Model

  attr_accessor :total_requests,
    :request_scale,
    :average_response_time_in_ms,
    :number_of_app_workers,
    :average_request_per_sec,
    :util_pct,
    :number_of_workers_per_cpu,
    :number_of_required_cpus,
    :memory_per_process,
    :memory_per_process_units,
    :one_hundred_utilization_requests

  with_options numericality: { greater_than: 0, integer: true } do |cf|
    cf.validates :total_requests
    cf.validates :average_response_time_in_ms
    cf.validates :util_pct
  end

  validates :util_pct,
    numericality: { greater_than: 0, less_than_or_equal_to: 100 }

  validates :request_scale, presence: true

  def submit
    return if invalid?
    return if total_requests.blank? || average_response_time_in_ms.blank?

    calc_instance_count
  end

  def calc_instance_count
    @util_pct ||= 40
    @average_request_per_sec = (
      case request_scale
      when 'second' then total_requests.to_i
      when 'minute' then Rational(total_requests.to_i, 1.minute)
      when 'hour'   then Rational(total_requests.to_i, 1.hour)
      when 'day'    then Rational(total_requests.to_i, 1.day,)
      when 'month'  then Rational(total_requests.to_i, 1.month)
      end
    ).to_f

    @number_of_app_workers = (
      average_request_per_sec * Rational(average_response_time_in_ms, 1_000) / Rational(util_pct, 100)
    ).ceil

    if util_pct.to_i < 100
      @one_hundred_utilization_requests = Rational(@number_of_app_workers, Rational(average_response_time_in_ms, 1000))
    end

    if number_of_workers_per_cpu.present?
      @number_of_required_cpus = Rational(@number_of_app_workers, number_of_workers_per_cpu).ceil
    end
  end

  def server_configs
    return [] unless [
      number_of_required_cpus,
      number_of_workers_per_cpu,
      recommended_memory_per_process,
      memory_per_process_units,
    ].all?(&:present?)

    ram_per_process = if memory_per_process_units == "mb"
                        recommended_memory_per_process
                      elsif memory_per_process_units == "gb"
                        recommended_memory_per_process * 1000
                      end

    Server.configs(number_of_required_cpus, number_of_workers_per_cpu.to_f, ram_per_process)
      .sort_by { |sr| sr.price_per_month * sr.quantity.ceil }
      .first(20)
  end

  def recommended_memory_per_process
    return unless memory_per_process.present? && memory_per_process_units.present?

    1.2 * memory_per_process.to_f
  end
end
