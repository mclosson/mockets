class Mocket
  @@ports = Hash.new(Hash.new(:ECONNREFUSED))
  LISTENING = :listening

  def initialize
    self.state = :open
  end

  def self.hostunreachable(host, port)
    self.setport(host, port, :EHOSTUNREACH)
  end

  def self.listen(host, port)
    self.setport(host, port, LISTENING)
  end

  def self.netunreachable(host, port)
    self.setport(host, port, :ENETUNREACH)
  end

  def self.open(host, port)
    state = self.portstate(host, port)
    return Mocket.new if state == LISTENING
    raise Errno.const_get(state)
  end

  def self.reset!
    @@ports = Hash.new(Hash.new(:ECONNREFUSED))
  end

  def self.timeout(host, port)
    self.setport(host, port, :ETIMEDOUT)
  end

  def close
    self.state = :closed
  end

  def write(bytes)
    raise IOError, 'closed stream' if state == :closed
    bytes.size
  end

  private

  attr_accessor :state

  def self.portstate(host, port)
    @@ports[host][port]
  end

  def self.setport(host, port, state)
    @@ports[host][port] = state
  end
end
