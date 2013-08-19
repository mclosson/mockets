require 'mocket'
require 'socket'

class SocketAdapter
  def initialize
    setstate(:live)
  end

  def setstate(state)
    raise ArgumentError unless valid_state?(state)
    self.state = state
  end

  def open(host, port)
    socketlib.open(host, port)
  end

  private

  attr_accessor :state

  def libraries
    @libraries ||= { live: TCPSocket, test: Mocket }
  end

  def socketlib
    libraries[state]
  end

  def valid_state?(state)
    [:live, :test].include?(state)
  end
end
