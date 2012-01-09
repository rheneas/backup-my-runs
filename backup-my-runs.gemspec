# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','backup-my-runs_version.rb'])

spec = Gem::Specification.new do |s| 
  s.name = 'backup-my-runs'
  s.version = "0.0.1"
  s.author = 'Rheneas'
  s.email = 'your@email.address.com'
  s.homepage = 'https://github.com/rheneas/backup-my-runs'
  s.platform = Gem::Platform::RUBY
  s.summary = 'Backs up your runkeeper activities'
# Add your other files here if you make them
  s.files = %w(
bin/backup-my-runs
  )
  s.require_paths << 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc','backup-my-runs.rdoc']
  s.rdoc_options << '--title' << 'backup-my-runs' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'backup-my-runs'
  s.add_development_dependency('rake')
  s.add_development_dependency('rdoc')
  s.add_runtime_dependency('mechanize')
  s.add_runtime_dependency('hpricot')
  s.add_runtime_dependency('gli')
end
