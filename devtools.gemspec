Gem::Specification.new do |spec|
  spec.name               = 'devtools'
  spec.licenses           = ['MIT']
  spec.version            = '0.0.1'
  spec.summary            = %q{Quick tools for developing in ruby.}
  spec.description        = %q{Provides quick tools that can be run on the
                               command line to aid in ruby development and
                               troubleshooting.}.
                               gsub(%r{^\s+}, ' ').gsub(%r{\n}, '')
  spec.authors            = ['Anthony Bargnesi']
  spec.date               = %q{2014-05-30}
  spec.email              = %q{abargnesi@gmail.com}
  spec.files              = Dir.glob('lib/**/*.rb') << 'LICENSE'
  spec.executables        = Dir.glob('bin/*').map(&File.method(:basename))
  spec.homepage           = 'https://github.com/abargnesi/devtools'
  spec.require_paths      = ["lib"]

  spec.add_dependency             'term-ansicolor', '~> 1.3'
  spec.add_development_dependency 'rake',           '~> 10.1'
  spec.add_development_dependency 'rspec',          '~> 2.14'
  spec.add_development_dependency 'yard',           '~> 0.8'
  spec.add_development_dependency 'rdoc',           '~> 4.0'
  spec.add_development_dependency 'bundler',        '~> 1.3'
end
# vim: ts=2 sw=2:
# encoding: utf-8
