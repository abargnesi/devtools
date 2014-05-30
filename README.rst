devtools
--------

Gem containing ruby development tools.

**Tools**

*srctrace.rb*

Trace through method execution of your program.

Features:

- Uses TracePoint API to provide return values
- Environment variable control (run ``srctrace`` for options)
- Terminal colors (``gem install term-ansicolor``)

.. code-block:: bash

  # run gem executable
  srctrace your-program.rb

  # require via ruby
  ruby -rsrctrace your-program.rb

  # show only line, call, and return event types
  SOURCE_TRACER_FILTERS="line,call,return" bin/srctrace your-program.rb

example output:

``ruby -rsrctrace prog1.rb``

.. code-block:: bash

  ...
  b_return   kernel_require.rb:0     Kernel#require                   ?
  c_call     test.rb:0               IO#set_encoding                  ?
  c_return   test.rb:0               IO#set_encoding                  ?
  c_call     test.rb:0               IO#set_encoding                  ?
  c_return   test.rb:0               IO#set_encoding                  ?
  line       test.rb:1               n/a                              1.times do
  c_call     test.rb:1               Integer#times                    1.times do
  b_call     test.rb:1               n/a                              1.times do
  line       test.rb:2               n/a                                "cool".to_sym
  c_call     test.rb:2               String#to_sym                      "cool".to_sym
  c_return   test.rb:2               String#to_sym                      "cool".to_sym
  b_return   test.rb:3               n/a                              end
  c_return   test.rb:1               Integer#times                    1.times do

``SOURCE_TRACER_FILTERS="line,return" SOURCE_TRACER_RETURNS=1 ruby -rsrctrace prog2.rb``

.. code-block:: bash

  line       kernel_require.rb:137   Kernel#require                         RUBYGEMS_ACTIVATION_MONITOR.enter
  line       monitor.rb:184          MonitorMixin#mon_enter             if @mon_owner != Thread.current
  line       monitor.rb:185          MonitorMixin#mon_enter               @mon_mutex.lock
  line       monitor.rb:186          MonitorMixin#mon_enter               @mon_owner = Thread.current
  line       monitor.rb:188          MonitorMixin#mon_enter             @mon_count += 1
  return     monitor.rb:189          MonitorMixin#mon_enter           end
  ↳ Fixnum: 1
  line       kernel_require.rb:143   Kernel#require                     RUBYGEMS_ACTIVATION_MONITOR.exit
  line       monitor.rb:195          MonitorMixin#mon_exit              mon_check_owner
  line       monitor.rb:245          MonitorMixin#mon_check_owner       if @mon_owner != Thread.current
  return     monitor.rb:248          MonitorMixin#mon_check_owner     end
  ↳ NilClass: nil
  line       monitor.rb:196          MonitorMixin#mon_exit              @mon_count -=1
  line       monitor.rb:197          MonitorMixin#mon_exit              if @mon_count == 0
  line       monitor.rb:198          MonitorMixin#mon_exit                @mon_owner = nil
  line       monitor.rb:198          MonitorMixin#mon_exit                @mon_owner = nil
  line       monitor.rb:199          MonitorMixin#mon_exit                @mon_mutex.unlock
  return     monitor.rb:201          MonitorMixin#mon_exit            end
  ↳ Mutex: #<Mutex:0x007f55c224b098>
  line       test.rb:1               n/a                            1.times do
  line       test.rb:2               n/a                              "cool".to_sym

