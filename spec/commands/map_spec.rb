require 'spec_helper'

describe Commands::Map do
  
  describe "#[]" do
    it "retrieves values when a specific key matches a regular expression" do
      subject[/^\d+$/] = "w00t"
      subject["1234"].should eq("w00t")
      subject["9123423423"].should eq("w00t")
      subject["a9123423423"].should be_nil
      subject["1234f"].should be_nil
    end
  end
end