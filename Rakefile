require 'rbconfig'
require 'bundler'

Bundler.setup
$:.unshift File.expand_path('../lib', __FILE__)

require 'rspec/core/rake_task'
require 'docker_task'

RSpec::Core::RakeTask.new('spec')
task :default => :spec

task :spec_all do
  ENV['INCLUDE_COMPILE_EXTRA_SPECS'] = '1'
  ENV['INCLUDE_INSTALL_SPECS'] = '1'

  Rake::Task['spec'].invoke
end

docker_run = lambda do |task, opts|
  opts << '-v %s:/build' % File.expand_path('../', __FILE__)
  opts
end

DockerTask.create({ :remote_repo => 'ruby',
                    :pull_tag => '2.5.1',
                    :image_name => 'fury-buildpack-fpm-ruby251',
                    :run => docker_run })

DockerTask.create({ :remote_repo => 'ruby',
                    :pull_tag => '1.9.3',
                    :image_name => 'fury-buildpack-fpm-ruby193',
                    :run => docker_run })

DockerTask.include_tasks(:use => 'fury-buildpack-fpm-ruby251')

desc 'Create bundle standalone'
task :bundle_standalone do
  ENV['SKIP_TARBALL'] = '1'
  Rake::Task['bundle_standalone_tarball'].invoke
end

desc 'Create bundled tarball'
task :bundle_standalone_tarball do
  root_path = File.expand_path('./')
  bundle_spath = File.expand_path('../bundle', __FILE__)

  skip_tarball = 'SKIP_TARBALL=1' unless ENV['SKIP_TARBALL'].nil?
  cmd = 'env %s %s/exec/create_vendored_gems %s %s' % [ skip_tarball, root_path, root_path, bundle_spath ]
  puts(cmd)
  Bundler.clean_system(cmd)

  puts 'Created bundle standalone path: %s' % bundle_spath
end

desc 'Create bundle for linux with ruby 2.5.1'
task :bundle_for_linux do
  c = DockerTask.containers['fury-buildpack-fpm-ruby251']
  c.pull; c.runi(:exec => '/build/exec/build_for_linux')
end

desc 'Create bundle for linux with ruby 1.9.3'
task :bundle_for_linux_ruby193 do
  c = DockerTask.containers['fury-buildpack-fpm-ruby193']
  c.pull; c.runi(:exec => '/build/exec/build_for_linux_ruby193')
end

desc 'Create rpm vendor for linux'
task :create_vendor_rpm_for_linux do
  c = DockerTask.containers['fury-buildpack-fpm-ruby193']
  c.pull; c.runi(:exec => '/build/exec/create_vendored_rpm')
end

desc 'Bash to ruby193 environment'
task :bash_to_ruby193 do
  c = DockerTask.containers['fury-buildpack-fpm-ruby193']
  c.runi
end

task :bundle_for_local => [ :bundle_standalone ]
