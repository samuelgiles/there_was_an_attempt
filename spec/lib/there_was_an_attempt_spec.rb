# typed: true
# frozen_string_literal: true

require 'logger'
require 'dry/monads/result'

describe ThereWasAnAttempt do
  let(:service) { described_class.new(intervals, wait) }

  let(:intervals) { [0.1, 0.2] }
  let(:sensor) { instance_double(Logger) }
  let(:wait) { ->(seconds) { sensor.info(seconds) } }

  describe '#attempt' do
    context 'when the block never succeeds' do
      subject(:result) do
        @my_result_block_attempt = 0

        service.attempt do
          Dry::Monads::Failure(false)
        end
      end

      specify do
        expect(sensor).to receive(:info).with(0.1)
        expect(sensor).to receive(:info).with(0.2)
        expect(result).to eq(Dry::Monads::Failure(false))
      end
    end

    context 'when the block eventually succeeds' do
      subject(:result) do
        @my_result_block_attempt = 0

        service.attempt do
          if @my_result_block_attempt == 1
            Dry::Monads::Success(true)
          else
            @my_result_block_attempt += 1
            Dry::Monads::Failure(false)
          end
        end
      end

      specify do
        expect(sensor).to receive(:info).with(0.1)
        expect(sensor).not_to receive(:info).with(0.2)
        expect(result).to eq(Dry::Monads::Success(true))
      end
    end
  end

  describe '.attempt' do
    subject(:result) do
      described_class.attempt do
        Dry::Monads::Success(true)
      end
    end

    specify do
      expect(result).to eq(Dry::Monads::Success(true))
    end
  end
end
