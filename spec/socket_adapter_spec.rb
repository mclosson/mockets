require 'socket_adapter'

describe SocketAdapter do
  let(:host) { '127.0.0.1' }
  let(:port) { 40000 }
  let(:socket_adapter) { SocketAdapter.new }

  describe '.setstate' do
    context 'valid input parameter' do
      it 'does not raise an error' do
        expect { socket_adapter.setstate(:live) }.not_to raise_error
        expect { socket_adapter.setstate(:test) }.not_to raise_error
      end
    end

    context 'invalid input parameter' do
      it 'raises ArgumentError' do
        expect { socket_adapter.setstate(:other) }.to raise_error(ArgumentError)
      end
    end
  end

  describe '.open' do
    context 'live mode' do
      it 'calls TCPSocket#open' do
        socket_adapter.setstate(:live)
        TCPSocket = double('TCPSocket')
        expect(TCPSocket).to receive(:open).with(host, port)
        socket_adapter.open(host, port)
      end
    end

    context 'test mode' do
      it 'calls Mocket#open' do
        socket_adapter.setstate(:test)
        Mocket = double('Mocket')
        expect(Mocket).to receive(:open).with(host, port)
        socket_adapter.open(host, port)
      end
    end
  end
end
