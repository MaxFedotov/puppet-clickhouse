require 'digest'
module Puppet::Parser::Functions
  newfunction(:clickhouse_password, type: :rvalue, doc: <<-EOS
    @summary
      Hash a string as for Clickhouse <password_sha256_hex> config
    @param [String] password Plain text password.
    @return [String] the Clickhouse <password_sha256_hex> password hash from the clear text password.
    EOS
    ) do |args|

    if args.size != 1
      raise Puppet::ParseError, _('clickhouse_password(): Wrong number of arguments given (%{args_length} for 1)') % { args_length: args.length }
    end

    return '' if args[0].empty?
    return args[0] if args[0] =~ %r{[A-Fa-f0-9]{64}$}
    Digest::SHA256.hexdigest(args[0])
  end
end
