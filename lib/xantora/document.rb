# frozen_string_literal: true

require "asciidoctor"
require "asciidoctor-pdf"

module Xantora
  # Document represents a Antora document and holds the functionality for PDF conversion based on asciidoctor-pdf
  class Document
    attr_reader :path

    GEM_DIR = File.expand_path("../..", __dir__)

    def initialize(path, options = {})
      @path = path
      @to_dir = options[:to_dir]
      @to_file = options[:to_file]
    end

    def page_component_title
      module_dir = File.expand_path "../../..", File.dirname(@path)
      begin
        YAML.load_file(
          File.join(module_dir, "antora.yml")
        )["title"]
      rescue StandardError
        ""
      end
    end

    def pdf_name
      name = File.basename(@path, ".adoc")
      if name == "index"
        doc = Asciidoctor.load_file @path, safe: :safe
        name = doc.doctitle.gsub(/[^0-9A-Za-z.\-]/, "_")
      end
      "#{name}.pdf"
    end

    def pdf_path(options)
      if !options[:output]
        pdf_name
      elsif options[:output].end_with? ".pdf"
        options[:output]
      else
        File.join options[:output], pdf_name
      end
    end

    def images_dir
      base_dir = File.expand_path("../..", @path)
      if Dir.exist? File.join(base_dir, "images")
        "../images"
      elsif Dir.exist? File.join(base_dir, "assets/images")
        "../assets/images"
      else
        ""
      end
    end

    def asciidoctor_options(options)
      a_opts = {}
      a_opts[:to_file] = pdf_path(options)
      a_opts[:backend] = "pdf"
      a_opts[:safe] = :unsafe
      a_opts[:attributes] = asciidoc_attributes(options[:attributes])
      a_opts
    end

    def asciidoc_attributes(optional_attributes = {})
      attributes = {
        "toc" => "auto",
        "toclevels" => "1",
        "pdf-theme" => "puzzle",
        "pdf-themesdir" => File.join(GEM_DIR, "asciidoctor-pdf/themes"),
        "pdf-fontsdir" => "#{File.join(GEM_DIR, "asciidoctor-pdf/fonts")};GEM_FONTS_DIR",
        "imagesdir" => images_dir
      }
      attributes.merge!({ "page-component-title" => page_component_title })
      attributes.merge(optional_attributes)
    end

    def convert_to_pdf(options = {})
      Asciidoctor.convert_file @path, asciidoctor_options(options)
    end
  end
end
