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
