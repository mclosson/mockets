require 'spec_helper'

describe Mocket do
  let(:bytes) { '12345' }
  let(:host) { '10.10.10.10' }
  let(:port) { 2600 }

  before(:each) do
    Mocket.reset!
  end

  describe '#reset!' do
    it 'sets all previously set host/ports back to connection refused' do
      Mocket.listen(host, port)
      Mocket.reset!
      expect { Mocket.open(host, port) }.to raise_error(Errno::ECONNREFUSED)
    end
  end

  describe '.open' do
    context 'host is not reachable' do
      it 'raises a host unreachable error' do
        Mocket.hostunreachable(host, port)
        expect { Mocket.open(host, port) }.to raise_error(Errno::EHOSTUNREACH)
      end
    end
    context 'network is not reachable' do
      it 'raises a net unreachable error' do
        Mocket.netunreachable(host, port)
        expect { Mocket.open(host, port) }.to raise_error(Errno::ENETUNREACH)
      end
    end

    context 'times out before getting a response from host' do
      it 'raises a timed out exception' do
        Mocket.timeout(host, port)
        expect { Mocket.open(host, port) }.to raise_error(Errno::ETIMEDOUT)
      end
    end

    context 'the port is closed' do
      it 'raises a connection refused error' do
        expect { Mocket.open(host, port) }.to raise_error(Errno::ECONNREFUSED)
      end
    end

    context 'host is reachable and port is open' do
      it 'returns an open mocket' do
        Mocket.listen(host, port)
        expect(Mocket.open(host, port)).to be_instance_of(Mocket)
      end
    end
  end

  describe '.write' do
    context 'mocket state is open' do
      it 'returns the number of bytes written' do
        Mocket.listen(host, port)
        mocket = Mocket.open(host, port)
        result = mocket.write(bytes)
        expect(result).to eq(bytes.size)
      end
    end

    context 'mocket state is closed' do
      it 'raises IOError: closed stream' do
        Mocket.listen(host, port)
        mocket = Mocket.open(host, port)
        mocket.close
        expect { mocket.write(bytes) }.to raise_error(IOError, 'closed stream')
      end
    end
  end
end
