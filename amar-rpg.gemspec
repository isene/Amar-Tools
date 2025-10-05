Gem::Specification.new do |spec|
  spec.name          = "amar-rpg"
  spec.version       = "2.1.5"
  spec.authors       = ["Geir Isene"]
  spec.email         = ["g@isene.com"]

  spec.summary       = "AMAR RPG Tools - Terminal UI and utilities for Amar RPG"
  spec.description   = "A comprehensive terminal UI for the Amar RPG with character generation, encounter management, weather generation, and complete campaign tools. Features both modern 3-tier and classic 2-tier character systems."
  spec.homepage      = "https://github.com/isene/Amar-Tools"
  spec.license       = "Unlicense"
  spec.required_ruby_version = Gem::Requirement.new(">= 3.0.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/isene/Amar-Tools"
  spec.metadata["changelog_uri"] = "https://github.com/isene/Amar-Tools/blob/master/README.md"

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir["amar-tui.rb", "includes/**/*", "cli_*.rb", "lib/**/*", "README.md", "LICENSE"]

  spec.bindir        = "."
  spec.executables   = ["amar-tui.rb"]
  spec.require_paths = ["lib", "includes"]

  # Runtime dependencies
  spec.add_runtime_dependency "rcurses", "~> 0.9"

  # Development dependencies
  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"

  spec.post_install_message = <<-MESSAGE

  ===========================================
  AMAR RPG Tools v2.1.5 has been installed!
  ===========================================

  To start the application:
    amar-tui.rb

  For more information:
    https://github.com/isene/Amar-Tools

  Enjoy your AMAR RPG adventures!

  MESSAGE
end