# frozen_string_literal: true

require "thor"
require "tty-spinner"
require "stringio"

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

    desc "convert", "Convert Antora document(s) to PDF"
    option :source,
           desc: "Antora document (.adoc) or modules path",
           aliases: %w[-s],
           required: true
    option :output,
           desc: "destination file or directory",
           aliases: %w[-o],
           default: Dir.pwd
    option :attributes,
           desc: "additional ascciidoc page attributes (attr1:value1 attr2:value2 ...)",
           type: :hash,
           aliases: %w[-a],
           default: {}
    option :to_attachments,
           desc: "place output in the modules attachment-dir",
           type: :boolean,
           aliases: %w[-A],
           default: false
    def convert
      if File.directory? options[:source]
        puts "[.] Scanning module directory for .adoc files ..."
        Dir.glob("#{options[:source]}/**/pages/*.adoc") { |file| convert_document(file, options) }
      elsif options[:source].end_with? ".adoc"
        convert_document(options[:source], options)
      else
        puts "[error] No valid source detected."
        exit 1
      end
    end

    no_tasks do
      def convert_document(file, options)
        doc = Document.new(file)
        spinner = TTY::Spinner.new(
          "[:spinner] Converting #{File.basename(doc.path)} to #{destination(doc, options)} ... ",
          format: :bouncing_ball
        )
        spinner.auto_spin
        capture_stderr { doc.convert_to_pdf(options) }
        spinner.success "(successful)"
      rescue StandardError => e
        spinner.error("(error: #{e.message})")
      end

      def destination(doc, options)
        options[:output]&.end_with?(".pdf") ? File.basename(options[:output]) : doc.pdf_name
      end

      def capture_stderr
        real_stderr = $stderr
        $stderr = StringIO.new
        yield
        $stderr.string
      ensure
        $stderr = real_stderr
      end
    end
  end
end
