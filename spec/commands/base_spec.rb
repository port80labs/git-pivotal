require 'spec_helper'

describe Commands::Base do
  
  before(:each) do
    @input = mock('input')
    @output = mock('output')
    
    # stub out git config requests
    Commands::Base.any_instance.stubs(:get).with { |v| v =~ /git config/ }.returns("")
  end
  
  it "should set the api key with the -k option" do
    @pick = Commands::Base.new("-k", "1234").with(@input, @output)
    @pick.options[:api_token].should == "1234"
  end
  
  it "should set the api key with the --api-token= option" do
    @pick = Commands::Base.new("--api-key=1234").with(@input, @output)
    @pick.options[:api_token].should == "1234"
  end
  
  it "should set the project id with the -p option" do
    @pick = Commands::Base.new("-p", "1").with(@input, @output)
    @pick.options[:project_id].should == "1"
  end
  
  it "should set the project id with the --project-id= option" do
    @pick = Commands::Base.new("--project-id=1").with(@input, @output)
    @pick.options[:project_id].should == "1"
  end
  
  it "should set the full name with the -n option" do
    @pick = Commands::Base.new("-n", "Jeff Tucker").with(@input, @output)
    @pick.options[:full_name].should == "Jeff Tucker"
  end
  
  it "should set the full name with the --full-name= option" do
    @pick = Commands::Base.new(@input, @output,"--full-name=Jeff Tucker")
    @pick.options[:full_name].should == "Jeff Tucker"
  end
  
  it "should set the quiet flag with the -q option" do
    @pick = Commands::Base.new("-q").with(@input, @output)
    @pick.options[:quiet].should be_true
  end
  
  it "should set the quiet flag with the --quiet option" do
    @pick = Commands::Base.new("--quiet").with(@input, @output)
    @pick.options[:quiet].should be_true
  end
  
  it "should set the verbose flag with the -v option" do
    @pick = Commands::Base.new("-v").with(@input, @output)
    @pick.options[:verbose].should be_true
  end
  
  it "should set the verbose flag with the --verbose option" do
    @pick = Commands::Base.new("--verbose").with(@input, @output)
    @pick.options[:verbose].should be_true
  end
  
  it "should unset the verbose flag with the --no-verbose option" do
    @pick = Commands::Base.new("--no-verbose").with(@input, @output)
    @pick.options[:verbose].should be_false
  end
  
  it "should respect verbose from git config if it's set true (case insensitive)" do
    Commands::Base.any_instance.stubs(:get).with("git config --get pivotal.verbose").returns("truE")
    @pick = Commands::Base.new
    @pick.options[:verbose].should be_true
  end

  it "should respect verbose from git config if it's set true (case insensitive)" do
    Commands::Base.any_instance.stubs(:get).with("git config --get pivotal.verbose").returns("falSe")
    @pick = Commands::Base.new
    @pick.options[:verbose].should be_false
  end

  it "should be verbose by default" do
    Commands::Base.any_instance.stubs(:get).with("git config --get pivotal.verbose").returns("")
    @pick = Commands::Base.new
    @pick.options[:verbose].should be_true
  end

  it "should print a message if the API token is missing" do
    @output.expects(:print).with("Pivotal Tracker API Token and Project ID are required\n")

    @pick = Commands::Base.new("-p", "1").with(@input, @output)
    @pick.run!
  end
  
  it "should print a message if the project ID is missing" do
    @output.expects(:print).with("Pivotal Tracker API Token and Project ID are required\n")

    @pick = Commands::Base.new("-k", "1").with(@input, @output)
    @pick.run!    
  end
  
  it "should set use_ssl to true with --use-ssl" do
    @pick = Commands::Base.new("--use-ssl").with(@input, @output)
    @pick.options[:use_ssl].should be_true
  end

  it "should set use_ssl to true with -S" do
    @pick = Commands::Base.new("-S").with(@input, @output)
    @pick.options[:use_ssl].should be_true
  end

  it "should set use_ssl to false by default" do
    @pick = Commands::Base.new("").with(@input, @output)
    @pick.options[:use_ssl].should be_false
  end

  it "should respect use_ssl from git config if it's set true (case insensitive)" do
    Commands::Base.any_instance.stubs(:get).with("git config --get pivotal.use-ssl").returns("truE")
    @pick = Commands::Base.new
    @pick.options[:use_ssl].should be_true
  end

  it "should respect use_ssl from git config if it's set to anything but true" do
    Commands::Base.any_instance.stubs(:get).with("git config --get pivotal.use-ssl").returns("not true")
    @pick = Commands::Base.new
    @pick.options[:use_ssl].should be_false
  end

end
