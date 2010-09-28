module Pdftk

  # Represents a fillable form field on a particular PDF
  class Field

    def self.alias_attribute method_name, attribute_name
      define_method(method_name) do
        attributes[attribute_name]
      end
      define_method("#{method_name}=") do |value|
        attributes[attribute_name] = value
      end
    end

    attr_accessor :attributes

    def initialize attributes
      @attributes = attributes
    end

    alias_attribute :name,  'FieldName'
    alias_attribute :type,  'FieldType'
    alias_attribute :value, 'FieldValue'
  end

end
