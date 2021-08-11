require "thor"
require "tty-spinner"

module Xantora

  class CLI < Thor
    # Error raised by this runner
    Error = Class.new(StandardError)

    def self.exit_on_failure?
      true
    end

    desc "version", "app version"
    def version
      puts "v#{Xantora::VERSION}"
    end
    map %w(--version -v) => :version

    desc "convert-document", "convert a single asciidoc document"
    option :file,
      desc: "source asciidoc file path",
      aliases: %w(-f),
      required: true
    option :output,
      desc: "destination file path",
      aliases: %w(-o)
    option :attributes,
      desc: "additional ascciidoc page attributes (attr1:value1 attr2:value2 ...)",
      type: :hash,
      aliases: %w(-a),
      default: {}
    def convert_document
      begin
        doc = Document.new(options[:file])
        destination = options[:to_file] ? File.basename(options[:to_file]) : doc.pdf_name
        spinner = TTY::Spinner.new("[:spinner] Converting #{File.basename(doc.path)} to #{destination} ... ")
        doc.convert_to_pdf(options)
        spinner.success "Done!"
      rescue Error => e
        spinner.error("(ERROR: #{e.message})")
      end
    end

    desc "convert-module", "convert all documents within an Antora module"
    option :module_path,
      desc: "Antora module path",
      aliases: %w(-m),
      required: true
    option :output,
      desc: "destination directory",
      aliases: %w(-o),
      default: Dir.pwd
    option :attributes,
      desc: "additional ascciidoc page attributes (attr1:value1 attr2:value2 ...)",
      type: :hash,
      aliases: %w(-a),
      default: {}
    def convert_module
      begin
        Dir.glob("#{options[:module_path]}/**/pages/*.adoc") do |file|
          doc = Document.new(file)
          destination = options[:to_file] ? File.basename(options[:to_file]) : doc.pdf_name
          spinner = TTY::Spinner.new("[:spinner] Converting #{File.basename(doc.path)} to #{destination} ... ")
          doc.convert_to_pdf(options)
          spinner.success "Done!"
        end
      rescue Error => e
        spinner.error("(ERROR: #{e.message})")
      end
    end

  end

end