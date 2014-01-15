require "bundler/gem_tasks"

require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'lib/sendwithus_ruby_action_mailer'
  t.test_files = FileList['test/lib/sendwithus_ruby_action_mailer/*_test.rb']
  t.verbose = true
end

task :default => :test
