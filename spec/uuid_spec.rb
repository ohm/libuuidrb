require 'lib_uuid'

module LibUUID
  describe UUID do
    def bytes(hex)
      [hex.gsub('-','')].pack('H*')
    end

    let(:base64url) { /\A[-\w]{22}\z/ }
    let(:canonical) { /\A\h{8}-\h{4}-\h{4}-\h{4}-\h{12}\z/ }

    let(:uuid_v1) { '6a9622b8-a422-11e3-be40-425861b86ab6' }
    let(:uuid_v3) { '5c8024b3-5a3d-31e4-b965-b3fc0e5bc8bf' }
    let(:uuid_v4) { '258b988d-e571-4c66-9588-227fec98b217' }
    let(:uuid_v5) { 'd34bc706-e2c6-5e9b-ac25-3bfae9d985fd' }

    describe '.guid' do
      subject(:guids) { 10.times.map { |i| UUID.guid } }

      it 'generates Version 4 UUIDs in canonical form' do
        expect(guids.size).to be(guids.uniq.size)
        guids.each { |guid| expect(guid).to match(canonical) }
      end
    end

    describe '.short_guid' do
      subject(:guids) { 10.times.map { |i| UUID.short_guid } }

      it 'generates Version 4 UUIDs encoded using RFC 4648 base64url' do
        expect(guids.size).to be(guids.uniq.size)
        guids.each { |guid| expect(guid).to match(base64url) }
      end
    end

    describe '.new' do
      it 'without arguments, generates a Version 4 UUID' do
        expect(subject).to be_a(UUID)
        expect(subject.type).to be(4)
      end

      it 'parses a UUID' do
        expect(UUID.new(uuid_v1)).to be_a(UUID)
        expect(UUID.new(uuid_v1).bytes).to eq(bytes(uuid_v1))

        expect(UUID.new(uuid_v4)).to be_a(UUID)
        expect(UUID.new(uuid_v4).bytes).to eq(bytes(uuid_v4))
      end

      it 'returns nil when the input is not a valid UUID' do
        expect(UUID.new('zzzzzzzz-zzzz-zzzz-zzzz-zzzzzzzzzzzz')).to be_nil
        expect(UUID.new('nope')).to be_nil
        expect(UUID.new('')).to be_nil
        expect(UUID.new(5)).to be_nil
      end

      it 'raises ArgumentError when there are too many arguments' do
        expect { UUID.new(subject.to_guid, subject.to_guid) }.to raise_error(ArgumentError)
      end
    end

    describe '#to_guid' do
      it 'is the canonical representation' do
        expect(subject.to_guid).to match(canonical)
        expect(UUID.new(uuid_v1).to_guid).to eq(uuid_v1)
        expect(UUID.new(uuid_v4).to_guid).to eq(uuid_v4)
      end
    end

    describe '#to_short_guid' do
      it 'is encoded using RFC 4648 base64url' do
        expect(subject.to_short_guid).to match(base64url)
        expect(UUID.new(uuid_v1).to_short_guid).to eq('apYiuKQiEeO-QEJYYbhqtg')
        expect(UUID.new(uuid_v4).to_short_guid).to eq('JYuYjeVxTGaViCJ_7JiyFw')
      end
    end

    describe '#type' do
      it 'is the version' do
        expect(UUID.new(uuid_v1).type).to be(1)
        expect(UUID.new(uuid_v4).type).to be(4)
      end
    end

    describe 'equality' do
      specify { expect(subject == subject).to be_true }
      specify { expect(subject).to eq(subject) }
      specify { expect(UUID.new(uuid_v1)).to eq(UUID.new(uuid_v1)) }

      specify { expect(subject).to_not eq(subject.to_guid) }
      specify { expect(subject).to_not eq(UUID.new) }
      specify { expect(subject).to_not eq(nil) }
    end
  end
end
