require "bundler/gem_tasks"

require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'lib/send_with_us_mailer'
  t.test_files = FileList['test/lib/send_with_us_mailer/*_test.rb']
  t.verbose = true
end

task :default => :test
