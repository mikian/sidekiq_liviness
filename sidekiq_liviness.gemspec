# frozen_string_literal: true

require_relative "lib/sidekiq_liviness/version"

Gem::Specification.new do |spec|
  spec.name = "sidekiq_liviness"
  spec.version = SidekiqLiviness::VERSION
  spec.authors = ["Mikko Kokkonen"]
  spec.email = ["mikko.kokkonen@itsmycargo.com"]
  spec.licenses = ["MIT"]

  spec.summary = "Liveness probe for Sidekiq on Kubernetes deployments."
  spec.description = "SidekiqLiviness offers a solution to add liveness probe of a Sidekiq instance."
  spec.homepage = "https://github.com/mikian/sidekiq_liviness"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["bug_tracker_uri"] = "#{spec.homepage}/issues"
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata["documentation_uri"] = spec.homepage.to_s
  spec.metadata["homepage_uri"] = spec.homepage.to_s
  spec.metadata["source_code_uri"] = spec.homepage.to_s

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["lib/**/*"]
  end
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "rack", "~> 2.2"
  spec.add_runtime_dependency "sidekiq", "~> 6", "> 6"
  spec.add_runtime_dependency "webrick", "~> 1.6"
end
