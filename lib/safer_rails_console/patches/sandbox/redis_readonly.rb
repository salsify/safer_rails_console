# frozen_string_literal: true

module SaferRailsConsole
  module Patches
    module Sandbox
      module RedisReadonly
        WRITE_COMMANDS = %w{
          bitop restore pfdebug lpushx incr move getex decrby renamenx flushdb setex
          setnx linsert rpush bzpopmax hset del copy xsetid georadiusbymember setrange blmove set rpop
          lset xtrim zrangestore psetex xclaim append georadius incrbyfloat bitfield expire sort hsetnx
          sadd zincrby lpop spop sunionstore getdel lrem zunionstore sdiffstore zremrangebyscore ltrim
          bzpopmin xack pfadd unlink swapdb sinterstore zrem xgroup hdel zdiffstore xautoclaim xdel hmset
          zpopmax zremrangebyrank setbit pexpireat mset hincrbyfloat incrby blpop getset expireat xreadgroup
          hincrby migrate lmove pexpire flushall smove msetnx decr persist rpushx pfmerge xadd zremrangebylex
          restore-asking geoadd rpoplpush zadd lpush srem brpoplpush zpopmin brpop geosearchstore zinterstore rename
        }

        def self.raise_exception_on_write_command(command)
          if WRITE_COMMANDS.include?(command)
            raise ::Redis::CommandError.new("Write commands are not allowed in readonly mode: #{command}")
          end
        end

        def self.handle_and_reraise_exception(error)
          if error.message.include?('Redis::CommandError')
            puts SaferRailsConsole::Colors.color_text( # rubocop:disable Rails/Output
              'An operation could not be completed due to read-only mode.',
              SaferRailsConsole::Colors::RED
            )
          end

          raise error
        end

        module RedisPatch
          def process(commands)
            commands.each do |command|
              begin
                raise_exception_on_write_command(command)
              rescue => e
                SaferRailsConsole::Patches::Sandbox::RedisReadonly.handle_and_reraise_exception(e)
              end
            end

            super
          end
        end

        if defined?(::Redis::Client)
          ::Redis::Client.prepend(RedisPatch)
        end
      end
    end
  end
end
