mockets
=======

Mock socket library for testing network applications

#### Reset all mock sockets to default of connection refused
```ruby
Mocket.reset!
Mocket.open('10.10.10.10', 25)
Exception: Errno:ECONNREFUSED
```

#### Set a host/port to host unreachable
```ruby
Mocket.hostunreachable('10.10.10.20', 25)
Mocket.open('10.10.10.20', 25)
Exception: Errno::EHOSTUNREACH
```

#### Set a host/port to connection timed out
```ruby
Mocket.timeout('10.10.20.20', 25)
Mocket.open('10.10.20.20', 25)
Exception: Errno::ETIMEDOUT
```

#### Set a host/port to return an open mocket
```ruby
Mocket.listen('10.10.10.30', 25)
mocket = Mocket.open('10.10.10.30', 25)
number_bytes_written = mocket.write('some message here')
mocket.close
```

#### Use SocketAdapter to interchange sockets with mockets on the fly
```ruby
class SocketClient
  attr_accessor :adapter
  delegate :open, :setstate, to: :adapter
  
  def initialize
    self.adapter = SocketAdapter.new
  end
end

# Connecting to a socket
client = SocketClient.new
client.setstate(:live)
server = TCPServer.open(4000)
socket = client.open('127.0.0.1', 4000)
socket.write('message...')
socket.close
server.close

# Connecting to a mocket
client = SocketClient.new
client.setstate(:test)
Mocket.listen('172.31.33.7', 5000)
socket = client.open('172.131.33.7', 5000)
socket.write('message...')
socket.close
Mocket.reset!
```
