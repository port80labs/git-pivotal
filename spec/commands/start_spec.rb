require 'spec_helper'

describe Commands::Start do

  describe '.for' do
    it "returns the Command::Bug when the first argument is bug" do
      Commands::Start.for("bug").should be_instance_of(Commands::Bug)
    end

    it "returns the Command::Chore when the first argument is chore" do
      Commands::Start.for("chore").should be_instance_of(Commands::Chore)
    end

    it "returns the Command::Feature when the first argument is feature" do
      Commands::Start.for("feature").should be_instance_of(Commands::Feature)
    end

    it "returns the Command::Card when the first argument is a card id" do
      Commands::Start.for("123456").should be_instance_of(Commands::Card)
    end

    it "raises when the command is unknown card type" do
      Commands::Start.expects(:display_usage_instructions_and_quit)
      Commands::Start.for("unknown")
    end
  end
  
end
