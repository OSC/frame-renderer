# config/initializers/ood_appkit.rb

OODClusters = OodCore::Clusters.new(
  OodAppkit.clusters.select(&:job_allow?).reject { |c| c.metadata.hidden }
)

OodAppkit.configure do |config|
  # Defaults
  config.files = OodAppkit::Urls::Files.new title: 'Files', base_url: '/pun/sys/files'
end