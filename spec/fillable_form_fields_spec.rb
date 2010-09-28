require File.dirname(__FILE__) + '/../lib/pdftk'

describe Pdftk::PDF do

  def path_to_pdf name
    File.join File.dirname(__FILE__), 'pdfs', "#{name}.pdf"
  end

  describe '#fields' do

    before do
      @pdf = Pdftk::PDF.new path_to_pdf(:employment_application)
      @pdf.clear_values
    end

    it 'can get total number of fields' do
      @pdf.fields.length.should == 125
    end

    it 'can get raw field attributes' do
      field = @pdf.fields.first
      field.attributes.length.should == 5
      field.attributes['FieldType'         ].should == 'Text'
      field.attributes['FieldName'         ].should == 'First name'
      field.attributes['FieldNameAlt'      ].should == 'Please enter First Name here'
      field.attributes['FieldFlags'        ].should == '0'
      field.attributes['FieldJustification'].should == 'Left'
    end
    
    it 'can get field #name' do
      @pdf.fields[0].name.should == 'First name'
      @pdf.fields[1].name.should == 'Middle name'
      @pdf.fields[2].name.should == 'Last name'
      @pdf.fields[3].name.should == 'Street Address'
      @pdf.fields[4].name.should == 'City'
    end

    it 'can get field #type' do
      @pdf.fields.map {|field| field.type }.uniq.sort.should == %w[ Button Choice Text ]
    end

    it 'can set and get the #value that we want to set' do
      @pdf.fields[3].value.should be_nil
      @pdf.fields[3].value = 'Filled in with code'
      @pdf.fields[3].value.should == 'Filled in with code'
    end

    it 'can easily get all of the #fields_with_values' do
      @pdf.fields[3].value = 'Filled in with code'
      @pdf.fields_with_values.length.should == 1

      @pdf.fields[1].value = 'Also Filled in with code'
      @pdf.fields_with_values.length.should == 2

      @pdf.fields[1].value = 'Changed the value of an already filled out field'
      @pdf.fields_with_values.length.should == 2
    end

    it 'can get the #xfdf that will be used to fill in the PDF' do
      @pdf.xfdf.should be_nil

      @pdf.fields[0].value = 'My Name'
      @pdf.xfdf.should_not be_nil
      @pdf.xfdf.should == "<?xml version='1.0' encoding='utf-8' ?>\n<xfdf xml:space='preserve' xmlns='http://ns.adobe.com/xfdf/'>\n  <fields>\n    <field name='First name'>\n      <value>My Name</value>\n    </field>\n  </fields>\n</xfdf>\n"
    end

    it 'can #export a PDF (with all of its values filled out)' do
      @pdf = Pdftk::PDF.new path_to_pdf(:employment_application)
      @pdf.fields[0].value.should be_nil
      
      @pdf.fields[0].value = 'Value set by code'
      tmp_path = Tempfile.new('pdftk-export-spec').path
      @pdf.export tmp_path

      Pdftk::PDF.new(tmp_path).fields[0].value.should == 'Value set by code'
    end

    it 'can #clear_values' do
      @pdf.fields[0].value = 'First'
      @pdf.fields[1].value = 'Middle'
      @pdf.fields[2].value = 'Last'
      @pdf.fields_with_values.length.should == 3
      
      @pdf.clear_values

      @pdf.fields_with_values.length.should == 0
    end

    #it 'can get fields by type' do
    #  @pdf.fields(:type => 'Text'  ).length.should == 1
    #  @pdf.fields(:type => 'Button').length.should == 1
    #  @pdf.fields(:type => 'Choice').length.should == 1
    #end

    #it 'can get field by name' do
    #  @pdf.field('First name').name.should == 'First name'
    #  @pdf.field(:City       ).name.should == 'City'
    #end
    
  end

end
