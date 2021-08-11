# frozen_string_literal: true

require_relative "lib/xantora/version"

Gem::Specification.new do |spec|
  spec.name          = "xantora"
  spec.version       = Xantora::VERSION
  spec.authors       = ["Nik Wolfgramm"]
  spec.email         = ["wolfgramm@puzzle.ch"]

  spec.summary       = "A PDF-exporter for Antora AsciiDoc documents."
  spec.description   = "A Ruby CLI-Tool which makes it easy to export PDF's from your Antora AsciiDoc-Files"
  spec.homepage      = "https://github.com/niwo/xantora"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.4.0"

  #spec.metadata["allowed_push_host"] = "TODO: Set to 'https://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "thor", "~> 1.1.0"
  spec.add_dependency "tty-spinner", '~> 0.9.3'
  spec.add_dependency "asciidoctor-pdf", '~> 1.6.0'
end
