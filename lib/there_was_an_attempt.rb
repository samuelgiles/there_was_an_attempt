# frozen_string_literal: true

require 'there_was_an_attempt/version'

class ThereWasAnAttempt
  module Intervals
    DEFAULT = [2, 4, 8, 16].freeze
  end

  module Wait
    WITH_SLEEP = ->(seconds) { sleep(seconds) }.freeze
  end

  module Reattempt
    ALWAYS = -> (failure) { true }.freeze
  end

  def initialize(intervals: Intervals::DEFAULT, wait: Wait::WITH_SLEEP, reattempt: Reattempt::ALWAYS)
    @intervals = intervals
    @wait = wait
    @reattempt = reattempt
  end

  def self.attempt(&block)
    new.attempt(&block)
  end

  def attempt(&block)
    @intervals.map do |seconds|
      result = block.call
      break [result] if result.success? || !reattempt?(result.failure)

      result.or { |failure| wait(seconds); Dry::Monads::Failure(failure) }
    end.last
  end

  private

  def wait(seconds)
    @wait.call(seconds)
  end

  def reattempt?(failure)
    @reattempt.call(failure)
  end
end
