#!/usr/bin/env ruby

# hose Kernel#puts
if ENV["SOURCE_TRACER_OMIT_PUTS"]
  module Kernel
    def puts(*args); end
  end
end

# additive String helpers
class String
  def rjust_relative(distance, string)
    rjust(distance - string.size + size)
  end
end

begin
  require 'term/ansicolor'
  class String
    include Term::ANSIColor
  end
  TERM_COLORS = false
rescue LoadError
  TERM_COLORS = true
end

class SourceTracer

  class << self
    attr_accessor :stdout
    attr_reader :stdout_mutex
    attr_accessor :filters
    attr_accessor :show_return_values
    alias show_return_values? show_return_values
    attr_accessor :term_colors
    alias term_colors? term_colors
  end

  SourceTracer::stdout = STDOUT
  SourceTracer::filters = ENV["SOURCE_TRACER_FILTERS"] ?
    ENV["SOURCE_TRACER_FILTERS"].split(',').map {|x| x.strip.to_sym} :
    [
      :line, :class, :end, :call, :return, :c_call, :c_return, :raise,
      :b_call, :b_return, :thread_begin, :thread_end
    ]
  SourceTracer::show_return_values = ENV["SOURCE_TRACER_RETURNS"]
  @stdout_mutex = Mutex.new

  def initialize
    @tp = TracePoint.new do |t|
      next if t.path == __FILE__
      next unless SourceTracer::filters.include? t.event

      SourceTracer::stdout_mutex.synchronize do
        if t.lineno == 0
          source = "?\n"
        else
          source = get_line(t.path, t.lineno)
        end

        loc = File.basename(t.path) + ":#{t.lineno}"
        klass = if not t.defined_class and not t.method_id
          "n/a"
        else
          "#{t.defined_class}##{t.method_id}"
        end
        out =  format(:event, t.event.to_s)
        out << format(:location, loc.rjust_relative(20, out))
        out << format(:class, klass.rjust_relative(60, out))
        out << format(:source, source.rjust_relative(140, out))
        stdout.print(out)

        if SourceTracer::show_return_values? and t.event == :return
          ret = t.return_value
          stdout.print(format(:return, "\u21B3 #{ret.class}: #{ret.inspect}\n"))
        end
      end
    end
  end

  Singleton = new

  def SourceTracer.on
    Singleton.on
  end

  def SourceTracer.off
    Singleton.off
  end

  def on # :nodoc:
    @tp.enable
  end

  def off # :nodoc:
    @tp.disable
  end

  def stdout
    SourceTracer.stdout
  end

  def get_line(file, line) # :nodoc:
    unless list = SCRIPT_LINES__[file]
      begin
        f = File::open(file)
        begin
          SCRIPT_LINES__[file] = list = f.readlines
        ensure
          f.close
        end
      rescue
        SCRIPT_LINES__[file] = list = []
      end
    end

    if l = list[line - 1]
      l
    else
      "-\n"
    end
  end

  def format(type, string)
    case type
    when :event
      (string.respond_to? :red) ? string.red : string
    when :location
      (string.respond_to? :yellow) ? string.yellow : string
    when :class
      (string.respond_to? :blue) ? string.blue : string
    when :source
      (string.respond_to? :green) ? string.green : string
    when :return
      (string.respond_to? :green) ? string.green : string
    end
  end
end

SCRIPT_LINES__ = {} unless defined? SCRIPT_LINES__

if $0 == __FILE__
  if ARGV.empty?
    $stdout.print("usage: ruby -rsrctrace PROGRAM\n")
    $stdout.print("     * ruby srctrace.rb PROGRAM\n")
    $stdout.print("     * ./srctrace.rb PROGRAM\n\n")
    $stdout.print("  environment vars\n")
    $stdout.print("    SOURCE_TRACER_FILTERS - comma-separated list of trace events to print\n")
    $stdout.print("      options - line, class, end, call, return, c_call, c_return,\n")
    $stdout.print("                raise, b_call, b_return, thread_begin, thread_end\n")
    $stdout.print("    SOURCE_TRACER_RETURNS - show ruby method return values\n")
    $stdout.print("    SOURCE_TRACER_OMIT_PUTS - silence Kernel#puts from PROGRAM\n")
    exit
  end

  $0 = ARGV[0]
  ARGV.shift
  SourceTracer.on
  require $0
else
# Called with "-r"?
  count = caller.count {|bt| %r%/rubygems/core_ext/kernel_require\.rb:% !~ bt}
  if (defined?(Gem) and count == 0) or
     (!defined?(Gem) and count <= 1)
    SourceTracer.on
  end
end
# vim: ts=2 sts=2 sw=2
# encoding: utf-8
