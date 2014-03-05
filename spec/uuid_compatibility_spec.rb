require 'lib_uuid'

describe LibUUID::UUID do
  begin
    require 'simple_uuid'

    describe 'compatibility with simple_uuid' do
      let(:simple) { SimpleUUID::UUID.new }

      it 'parses GUIDs' do
        LibUUID::UUID.new(simple.to_guid).tap do |uuid|
          expect(uuid).to_not be_nil
          expect(uuid.to_guid).to eq(simple.to_guid)
          expect(uuid.type).to be(1)
          expect(uuid.variant).to be(1)
        end
      end
    end
  rescue LoadError => e
    puts "Skipping compatibility test: #{e.message}"
  end

  begin
    require 'uuidtools'

    describe 'compatibility with UUIDTools' do
      let(:random) { UUIDTools::UUID.random_create }
      let(:timestamp) { UUIDTools::UUID.timestamp_create }

      it 'parses random GUIDs' do
        LibUUID::UUID.new(random.to_s).tap do |uuid|
          expect(uuid).to_not be_nil
          expect(uuid.to_guid).to eq(random.to_s)
          expect(uuid.type).to be(4)
          expect(uuid.variant).to be(1)
        end
      end

      it 'parses timestamp GUIDs' do
        LibUUID::UUID.new(timestamp.to_s).tap do |uuid|
          expect(uuid).to_not be_nil
          expect(uuid.to_guid).to eq(timestamp.to_s)
          expect(uuid.type).to be(1)
          expect(uuid.variant).to be(1)
        end
      end
    end
  rescue LoadError => e
    puts "Skipping compatibility test: #{e.message}"
  end
end
