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

.. code-block:: bash

  ...
  b_return   kernel_require.rb:0     Kernel#require       ?
  c_call     test.rb:0               IO#set_encoding      ?
  c_return   test.rb:0               IO#set_encoding      ?
  c_call     test.rb:0               IO#set_encoding      ?
  c_return   test.rb:0               IO#set_encoding      ?
  line       test.rb:1               n/a                  1.times do |x|
  c_call     test.rb:1               Integer#times        1.times do |x|
  b_call     test.rb:1               n/a                  1.times do |x|
  line       test.rb:2               n/a                  "cool".to_sym
  c_call     test.rb:2               String#to_sym        "cool".to_sym
  c_return   test.rb:2               String#to_sym        "cool".to_sym
  b_return   test.rb:3               n/a                  end
  c_return   test.rb:1               Integer#times        1.times do |x|


