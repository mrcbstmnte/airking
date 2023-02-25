# frozen_string_literal: true

class ApplicationService
  class << self
    def arguments(*arguments)
      arguments.each do |argument|
        argument_name = argument.to_s

        if argument_name.last == '?'
          name_without_question_mark = argument_name.chomp('?').to_sym

          attr_accessor name_without_question_mark
          alias_method argument, name_without_question_mark
        else
          attr_accessor argument
        end
      end
    end
  end

  attr_reader :args

  def initialize(args = {})
    expect_hash!(args)

    @args = args

    @args.each do |k, v|
      raise ArgumentError, "Unknown argument #{k}" unless respond_to?("#{k}=")

      public_send "#{k}=", v
    end
  end

  def self.run(args = {})
    service = new(args)
    logger = Rails.logger

    begin
      service.perform.tap do |output|
        logger.debug "complete out=#{output.inspect}"
      end
    rescue StandardError => e
      logger.error "fail err=#{e.class.name} msg=#{e.message}"
      raise
    end
  end

  def perform
    raise "#{self.class.name} does not define #perform"
  end

  private

  def expect_hash!(args)
    raise ArgumentError, 'Expected a hash' unless args.is_a?(Hash)
  end
end
