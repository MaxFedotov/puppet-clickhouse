require 'xmlsimple'
module Puppet::Parser::Functions
  newfunction(:clickhouse_config, type: :rvalue, doc: <<-EOS
    @summary
      Convert hash to Clickhouse XML config.
    @param [Hash] Settings for Clickhouse Server.
    @return [Xml] Clickhouse XML configuration.
    EOS
             ) do |args|

    if args.size != 1
      raise Puppet::ParseError, _('clickhouse_config(): Wrong number of arguments given (%{args_length} for 1)') % { args_length: args.length }
    end

    args.each do |arg|
      if arg.class != Hash
        raise Puppet::ParseError, _('clickhouse_config(): Wrong type of arguments given (%{args_class} for Hash)') % { args_class: args.class }
      end
    end

    XmlSimple.xml_out(args[0], 'RootName' => 'yandex', 'AttrPrefix' => true)
  end
end
