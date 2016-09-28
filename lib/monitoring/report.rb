require 'usagewatch_ext'
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
    attr_reader :process_limit, :delay
    def initialize(process_limit = 10, delay = 10)
      puts "Hello, I'm on Report"
      @process_limit = process_limit
      @delay = delay

      if OS.linux?
        @cpu = CPU::Load.new
      end

    end

    def get_metrics
      {
        # limit: limit,
        # delay: delay,
        hostname: hostname,
        cpu_usage: cpu_usage,
        disk_usage: disk_usage,
        token: ENV['server_token'],
        running_processes: processes
      }
    end

    def hostname
      `hostname`.chomp
    end

    def disk_stat
      Filesystem.stat('/')
    end

    def cpu_usage
      uw = Usagewatch
      if OS.linux?
        @cpu.last_minute
      else
        uw.uw_cpuused
      end
    end

    def disk_usage
      used = number_to_human_size(disk_stat.bytes_used)
      total = number_to_human_size(disk_stat.bytes_total)
      return "#{used} of #{total}"
    end

    def processes
      if OS.linux?
        processes = `ps --no-headers aux | awk '{print $11, $2, $3, $4}' | sort -k3nr  | head -n #{process_limit}`
      else
        processes = `ps aux | awk '{print $11, $2, $3, $4}' | sort -rk 3,3  | head -n #{process_limit}`
      end
      headers = [:command, :pid, :cpu, :mem]

      res = []
      arr = processes.chomp.split("\n")
      arr.each do |item|
        hsh = {}
        el = item.split(" ")
        el.each_with_index do |i, ind|
          hsh[headers[ind]] = i
        end
        res << hsh
      end
      res
    end

  end
end
