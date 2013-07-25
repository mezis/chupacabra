require 'spec_helper'

describe Chupacabra::System do

  let(:password) { "asd\" '," }

  before do
    described_class.stub(:ask_for_password =>  "text returned:#{password}, button returned:OK\n")
  end

  describe '.get password' do
    subject { described_class.get_password }

    it 'returns password' do
      subject.should == password
    end

    it 'stores once provided password' do
      described_class.get_password
      described_class.stub(:ask_for_password =>  "Something different")
      subject.should == password
    end
  end
end