require 'rubygems'
require 'pivotal-tracker'
require 'optparse'

module Commands
  class Base

    attr_accessor :input, :output, :options

    def initialize(*args)
      @input = STDIN
      @output = STDOUT

      @options = {}

      parse_gitconfig
      parse_argv(*args)
    end
    
    def with(input, output)
      tap do
        @input = input
        @output = output
      end
    end

    def put(string, newline=true)
      @output.print(newline ? string + "\n" : string) unless options[:quiet]
    end

    def sys(cmd)
      if options[:verbose]
        put cmd
        system cmd
      else
        system "#{cmd} > /dev/null 2>&1"
      end
    end

    def get(cmd)
      put cmd if options[:verbose]
      `#{cmd}`
    end

    def get_char
      input.getc
    end

    def run!
      unless options[:api_token] && options[:project_id]
        put "Pivotal Tracker API Token and Project ID are required"
        return 1
      end

      PivotalTracker::Client.token = options[:api_token]
      PivotalTracker::Client.use_ssl = options[:use_ssl]

      return 0
    end

  protected
  
    def on_parse(opts)
      # no-op, override in sub-class to provide command specific options
    end

    def current_branch
      @current_branch ||= get('git symbolic-ref HEAD').chomp.split('/').last
    end

    def project
      @project ||= PivotalTracker::Project.find(options[:project_id])
    end
    
    def full_name
      options[:full_name]
    end
    
    def remote
      options[:remote] || "origin"
    end
    
  private

    def parse_gitconfig
      token              = get("git config --get pivotal.api-token").strip
      name               = get("git config --get pivotal.full-name").strip
      id                 = get("git config --get pivotal.project-id").strip
      remote             = get("git config --get pivotal.remote").strip
      use_ssl            = get("git config --get pivotal.use-ssl").strip
      verbose            = get("git config --get pivotal.verbose").strip

      options[:api_token]          = token              unless token == ""
      options[:project_id]         = id                 unless id == ""
      options[:full_name]          = name               unless name == ""
      options[:remote]             = remote             unless remote == ""
      options[:use_ssl] = (/^true$/i.match(use_ssl))
      options[:verbose] = verbose == "" ? true : (/^true$/i.match(verbose))
    end

    def parse_argv(*args)
      OptionParser.new do |opts|
        opts.banner = "Usage: git pick [options]"
        opts.on("-k", "--api-key=", "Pivotal Tracker API key") { |k| options[:api_token] = k }
        opts.on("-p", "--project-id=", "Pivotal Tracker project id") { |p| options[:project_id] = p }
        opts.on("-n", "--full-name=", "Pivotal Tracker full name") { |n| options[:full_name] = n }
        opts.on("-S", "--use-ssl", "Use SSL for connection to Pivotal Tracker (for private repos(?))") { |s| options[:use_ssl] = s }
        opts.on("-D", "--defaults", "Accept default options. No-interaction mode") { |d| options[:defaults] = d }
        opts.on("-q", "--quiet", "Quiet, no-interaction mode") { |q| options[:quiet] = q }
        opts.on("-v", "--[no-]verbose", "Run verbosely") { |v| options[:verbose] = v }
        opts.on("-f", "--force", "Do not prompt") { |f| options[:force] = f }
        
        on_parse(opts)
        
        opts.on_tail("-h", "--help", "This usage guide") { put opts.to_s; exit 0 }
      end.parse!(args)
    end

  end
end
