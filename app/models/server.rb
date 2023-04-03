class Server < ApplicationRecord
  default_scope { where.not(cpu: nil).where.not(price_per_month_cents: 0) }

  scope :distinct_cpu_counts, -> { select(:cpu).distinct }

  scope :configs, -> (total_cpus, worker_per_cpu, ram_per_worker) {
    ram_per_cpu = worker_per_cpu * ram_per_worker

    where("ram / cpu >= ?", ram_per_cpu)
      .select("(ram / cpu - #{ram_per_cpu}) / (ram / cpu) as mem_efficiency")
      .select("cpu * #{worker_per_cpu} as worker_count")
      .select("*")
      .select("#{total_cpus.to_f} / cpu as quantity")
  }

  monetize :price_per_month_cents
end
