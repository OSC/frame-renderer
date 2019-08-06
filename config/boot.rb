require 'pathname'

ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' # Set up gems listed in the Gemfile.

ENV['OOD_DATAROOT'] = Pathname.new(ENV['HOME'])
                              .join('ondemand', 'data', 'video-processing')
                              .expand_path.to_s
