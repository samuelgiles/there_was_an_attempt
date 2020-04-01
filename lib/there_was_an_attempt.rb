# frozen_string_literal: true

require 'there_was_an_attempt/version'

class ThereWasAnAttempt
  BACKOFF_INTERVALS_IN_SECONDS = [2, 4, 8, 16].freeze
  DEFAULT_WAIT = ->(seconds) { sleep(seconds) }.freeze

  def initialize(intervals = BACKOFF_INTERVALS_IN_SECONDS, wait = DEFAULT_WAIT)
    @intervals = intervals
    @wait = wait
  end

  def self.attempt(&block)
    new.attempt(&block)
  end

  def attempt(&block)
    @intervals.map do |seconds|
      result = block.call
      break [result] if result.success?

      result.or { |failure| wait(seconds); Dry::Monads::Failure(failure) }
    end.last
  end

  private

  def wait(seconds)
    @wait.call(seconds)
  end
end
