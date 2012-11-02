module Commands
  class Map < Hash
    def [](arg)
      super || (
        key = keys.detect{ |e| !arg.nil? && e.respond_to?(:match) && e.match(arg) }
        super key
      )
    end
  end
end
