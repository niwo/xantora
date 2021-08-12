# frozen_string_literal: true

require "thor"
require "tty-spinner"

module Xantora
  # Class responsible for the CLI logic based on thor
  class CLI < Thor
    # Error raised by this runner
    Error = Class.new(StandardError)

    def self.exit_on_failure?
      true
    end

    desc "version", "Xantora version"
    def version
      puts "v#{Xantora::VERSION}"
    end
    map %w[--version -v] => :version

    attributes_option = [
      :attributes, {
        desc: "additional ascciidoc page attributes (attr1:value1 attr2:value2 ...)",
        type: :hash,
        aliases: %w[-a],
        default: {}
      }
    ]

    desc "convert-document", "Convert a single asciidoc document"
    option :source,
           desc: "source Antora document path",
           aliases: %w[-s],
           required: true
    option :output,
           desc: "destination file",
           aliases: %w[-o]
    method_option(*attributes_option)
    def convert_document
      convert(options[:source], options)
    end

    desc "convert-module", "Convert all documents within an Antora module"
    option :source,
           desc: "Antora module path",
           aliases: %w[-s],
           required: true
    option :output,
           desc: "destination directory",
           aliases: %w[-o],
           default: Dir.pwd
    method_option(*attributes_option)
    def convert_module
      puts "[.] Scanning module directory for .adoc files ..."
      Dir.glob("#{options[:source]}/**/pages/*.adoc") do |file|
        convert(file, options)
      end
    end

    no_tasks do
      def convert(file, options)
        doc = Document.new(file)
        spinner = TTY::Spinner.new(
          "[:spinner] Converting #{File.basename(doc.path)} to #{destination(doc, options)} ... ",
          format: :bouncing_ball
        )
        spinner.auto_spin
        doc.convert_to_pdf(options)
        spinner.success "Done!"
      rescue Error => e
        spinner.error("(ERROR: #{e.message})")
      end

      def destination(doc, options)
        if options[:output]&.end_with?(".pdf")
          File.basename(options[:output])
        else
          doc.pdf_name
        end
      end
    end
  end
end
