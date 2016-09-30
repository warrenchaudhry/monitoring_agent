require 'rest-client'
require 'json'
require 'yaml'
require 'cli-parser'
require 'cpu'
require 'sys/filesystem'
require 'os'
module Monitoring
  class Report
    include Sys
    include ActionView::Helpers::NumberHelper
    attr_reader :process_limit
    def initialize(process_limit = 10)
      @process_limit = process_limit
      if OS.linux?
        @cpu = CPU::Load.new
      end
    end

    def get_metrics
      {
        hostname: hostname,
        cpu_usage: cpu_usage.gsub("\n", ""),
        total_disk_space: total_disk_space,
        used_disk_space: used_disk_space,
        disk_remaining_percent: disk_remaining_percent,
        running_processes: processes,
        fetch_time: Time.now
      }.to_json
    end

    def hostname
      `hostname`.chomp
    end

    def disk_stat
      Filesystem.stat('/')
    end

    def cpu_usage
      if OS.linux?
        "#{@cpu.last_minute}"
      else
        `ps -A -o %cpu | awk '{s+=$1} END {print s}'`.chomp
      end
    end

    def total_disk_space
      disk_stat.bytes_total
    end

    def used_disk_space
      disk_stat.bytes_used
    end

    def disk_remaining_percent
      100 - ((used_disk_space.to_f / total_disk_space.to_f) * 100).round(2)
    end

    def processes
      if OS.linux?
        processes = `ps --no-headers aux | awk '{print $11, $2, $3, $4, $1}' | sort -k3nr  | head -n #{process_limit}`
      else
        processes = `ps aux | awk '{print $11, $2, $3, $4, $1 }' | sort -k3nr  | head -n #{process_limit}`
      end
      headers = [:command, :pid, :cpu, :mem, :user]

      res = []
      arr = processes.chomp.split("\n")
      arr.each do |item|
        hsh = {}
        el = item.split(" ")
        el.each_with_index do |i, ind|
          if ind == 0
            command = i.split('/')[-1]
            hsh[headers[ind]] = command
          else
            hsh[headers[ind]] = i
          end

        end
        res << hsh
      end
      res
    end

    class << self
      def publish
        report = Report.new
        metrics = report.get_metrics
        MetricsBroadcastJob.perform_later(metrics)
      end
    end

  end
end
