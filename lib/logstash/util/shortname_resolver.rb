require 'resolv'
require 'mini_cache'

class ShortNameResolver
  def initialize(ttl:, logger:)
    @ttl = ttl
    @store = MiniCache::Store.new
    @logger = logger
  end

  private
  def resolve_cached(shortname)
    @store.get_or_set(shortname) do
      addresses = resolve(shortname)
      raise "Bad shortname '#{shortname}'" if addresses.empty?
      MiniCache::Data.new(addresses, expires_in: @ttl)
    end
  end

  private
  def resolve(shortname)
    addresses = Resolv::DNS.open do |dns|
      dns.getaddresses(shortname).map { |r| r.to_s }
    end
 
    @logger.info("Resolved shortnameaa '#{shortname}' to addresses #{addresses} #{addresses.class}")
    
    return [shortname]
  end

  public
  def get_address(shortname)
    a = resolve_cached(shortname).sample
    puts a.class
    @logger.info("the type of return object is '#{a.class}'")
    return a
  end

  public
  def get_addresses(shortname)
    a = resolve_cached(shortname)
    puts a.class
    @logger.info("the type of return object is '#{a.class}'")
    return a
  end
end
