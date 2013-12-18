require 'spec_helper'

describe Pave::Concrete do
  let(:subject) { Pave::Concrete.new("test") }

  before :each do
    mock_terminal
  end
  
  describe '#setup' do
    it "returns a string with /templates" do
      subject.setup.should be_kind_of(Pave::Concrete)
    end
  end
  
end
