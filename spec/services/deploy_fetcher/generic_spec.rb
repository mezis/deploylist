require 'rails_helper'

describe DeployFetcher::Generic do
  let(:logger) { instance_double('DeployLogger') }
  let(:adapter) { double('adapter') }
  let(:payloads) {[ %w[deploy1 deploy2], %w[deploy3] ]}

  subject { described_class.new(adapter, logger) }

  describe '#call' do
    before do
      allow(adapter).to receive(:fetch) do |&b|
        payloads.each { |p| b.call p }
      end
    end

    it 'passes deploys to the importer' do
      expect(DeployImporter).to receive(:import).with(%w[deploy1 deploy2])
      expect(DeployImporter).to receive(:import).with(%w[deploy3])
      subject.call
    end
  end
end
