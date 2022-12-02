# frozen_string_literal: true

module SaferRailsConsole
  module Patches
    module Sandbox
      module RedisReadonly
        READ_COMMANDS = [
          'hvals', 'bitcount', 'zscan', 'hget', 'smembers', 'hrandfield', 'zrevrange', 'bitpos', 'hlen', 'xlen', 'post',
          'zscore', 'dbsize', 'get', 'hstrlen', 'zrangebylex', 'scan', 'georadiusbymember_ro', 'zmscore', 'smismember',
          'zcount', 'lrange', 'stralgo', 'zrank', 'pttl', 'lpos', 'geopos', 'ttl', 'zrangebyscore', 'sdiff', 'llen',
          'sismember', 'zrevrangebyscore', 'zdiff', 'zrandmember', 'geodist', 'hexists', 'zrange', 'hmget', 'lindex',
          'zrevrangebylex', 'sunion', 'randomkey', 'zrevrank', 'xrange', 'xpending', 'hgetall', 'getrange', 'exists',
          'keys', 'georadius_ro', 'lolwut', 'hscan', 'object', 'zlexcount', 'type', 'geohash', 'touch', 'hkeys',
          'strlen', 'scard', 'substr', 'zinter', 'srandmember', 'mget', 'xinfo', 'geosearch', 'zunion', 'xread',
          'pfcount', 'xrevrange', 'sscan', 'memory', 'bitfield_ro', 'dump', 'host:', 'sinter', 'getbit', 'zcard'
        ].freeze

        def self.raise_exception_on_write_command(command, service = ::Redis)
          unless READ_COMMANDS.include?(command.downcase.to_s)
            raise "#{service}".constantize::CommandError.new("Write commands are not allowed in readonly mode: #{command}")
          end
        end

        def self.handle_and_reraise_exception(error)
          if error.message.include?('Write commands are not allowed')
            puts SaferRailsConsole::Colors.color_text( # rubocop:disable Rails/Output
              'An operation could not be completed due to read-only mode.',
              SaferRailsConsole::Colors::RED
            )
          end

          raise error
        end

        module RedisPatch
          def process(commands)
            begin
              command = commands.flatten.first
              SaferRailsConsole::Patches::Sandbox::RedisReadonly.raise_exception_on_write_command(command)
            rescue Redis::CommandError => e
              SaferRailsConsole::Patches::Sandbox::RedisReadonly.handle_and_reraise_exception(e)
            end
            super
          end
        end

        module RedisClientPatch
          def call(commands, redis_config)
            command = commands.first
            begin
              SaferRailsConsole::Patches::Sandbox::RedisReadonly.raise_exception_on_write_command(command, ::RedisClient)
            rescue RedisClient::CommandError => e
              SaferRailsConsole::Patches::Sandbox::RedisReadonly.handle_and_reraise_exception(e)
            end
            super
          end
        end

        ::Redis::Client.prepend(RedisPatch) if defined?(::Redis::Client)
        ::RedisClient.register(RedisClientPatch) if defined?(::RedisClient)
      end
    end
  end
end
