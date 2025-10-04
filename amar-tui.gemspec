Gem::Specification.new do |spec|
  spec.name          = "amar-tui"
  spec.version       = "2.1.0"
  spec.authors       = ["Geir Isene"]
  spec.email         = ["g@isene.com"]

  spec.summary       = "AMAR Tools TUI - Terminal UI for Amar RPG"
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

  ==========================================
  AMAR Tools TUI v2.1.0 has been installed!
  ==========================================

  NOTE: This gem has been renamed to 'amar-rpg'.
  Please install 'amar-rpg' instead:
    gem install amar-rpg

  To start the TUI application:
    amar-tui.rb

  For more information:
    https://github.com/isene/Amar-Tools

  Enjoy your AMAR RPG adventures!

  MESSAGE
end