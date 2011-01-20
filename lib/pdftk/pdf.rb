module Pdftk

  # Represents a PDF
  class PDF
    attr_accessor :path

    def initialize path
      @path = path
    end

    def fields_with_values
      fields.reject {|field| field.value.nil? or field.value.empty? }
    end

    def clear_values
      fields_with_values.each {|field| field.value = nil }
    end

    def export(output_pdf_path, options = {})
      xfdf_path = Tempfile.new('pdftk-xfdf').path
      File.open(xfdf_path, 'w'){|f| f << xfdf }
      system %{pdftk "#{path}" #{'flatten' if options[:flatten]} fill_form "#{xfdf_path}" output "#{output_pdf_path}"}
    end

    def xfdf
      @fields = fields_with_values

      if @fields.any?
        haml_view_path = File.join File.dirname(__FILE__), 'xfdf.haml'
        Haml::Engine.new(File.read(haml_view_path)).render(self)
      end
    end

    def fields
      unless @_all_fields
        field_output = `pdftk "#{path}" dump_data_fields`
        raw_fields   = field_output.split(/^---\n/).reject {|text| text.empty? }
        @_all_fields = raw_fields.map do |field_text|
          attributes = {}
          field_text.scan(/^(\w+): (.*)$/) do |key, value|
            attributes[key] = value
          end
          Field.new(attributes)
        end
      end
      @_all_fields
    end
  end

end
