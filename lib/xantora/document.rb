require "asciidoctor"
require "asciidoctor-pdf"

module Xantora
  class Document

    attr_reader :path

    def initialize(path, options = {})
      @path = path
      @to_dir = options[:to_dir]
      @to_file = options[:to_file]
    end

    def pdf_name
      name = File.basename(@path, ".adoc")
      if name == "index"
        doc = Asciidoctor.load_file @path, safe: :safe
        name = doc.doctitle.downcase.tr(" ", "")
      end
      name + ".pdf"
    end

    def convert_to_pdf(opts = {})
      opts[:to_file] ||= self.pdf_name 
      opts[:backend] = "pdf"
      opts[:safe] = :unsafe
      Asciidoctor.convert_file @path, opts
    end
  
  end
end