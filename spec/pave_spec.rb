require 'spec_helper'

describe Pave do
  
  before :each do
    mock_terminal
  end
  
  describe '.template_folder' do
    it "returns a string with /templates" do
      Pave.template_folder.should include("/templates")
    end
  end
  
end
