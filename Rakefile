# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'minitest/test_task'

Minitest::TestTask.create

require 'rubocop/rake_task'

RuboCop::RakeTask.new

namespace :rbs do
  desc 'Validate the RBS signatures'
  task :validate do
    sh 'rbs', '-I', 'sig', '-r', 'date', '-r', 'json', '-r', 'pathname', '-r', 'time', 'validate'
  end
end

task default: %i[test rubocop rbs:validate]
