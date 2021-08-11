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

    desc "convert-file", "convert a single asciidoc file"
    option :file,
      desc: "source asciidoc file path",
      aliases: %w(-f),
      required: true
    option :to_file,
      desc: "destination file path",
      aliases: %w(-o)
    def convert_file
      begin
        doc = Document.new(options[:file])
        spinner = TTY::Spinner.new("[:spinner] Converting #{File.basename(doc.path)} to #{doc.pdf_name} ... ")
        doc.convert_to_pdf(asciidoctor_options(options))
        spinner.success "Done!"
      rescue Error => e
        spinner.error("(ERROR: #{e.message})")
      end
    end

    no_commands do
      def asciidoctor_options(options)
        gem_dir = File.expand_path("../..", __dir__)
        a_opts = {}
        a_opts[:to_file] = options[:to_file] if options[:to_file]
        a_opts[:attributes] = [
          "toc=auto",
          "toclevels=1",
          "toc-title=Inhaltsverzeichnis",
          "imagesdir=../images",
          "pdf-theme=puzzle",
          "pdf-themesdir=#{File.join(gem_dir, 'asciidoctor-pdf/themes')}",
          "pdf-fontsdir=#{File.join(gem_dir, 'asciidoctor-pdf/fonts')}"
        ]
        a_opts
      end
    end

  end

end