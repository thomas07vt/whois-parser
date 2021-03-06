require_relative 'base'

module Whois
  class Parsers

    # Parser for the whois.dot.tk server.
    #
    # @note This parser is just a stub and provides only a few basic methods
    #   to check for domain availability and get domain status.
    #   Please consider to contribute implementing missing methods.
    #
    # @see Whois::Parsers::Example
    #   The Example parser for the list of all available methods.
    #
    class WhoisDotMl < Base

      property_supported :status do
        if available?
          :available
        else
          :registered
        end
      end

      property_supported :available? do
        !!(content_for_scanner =~ /domain name not known/)
      end

      property_supported :registered? do
        !available?
      end


      property_supported :created_on do
        if content_for_scanner =~ /Domain registered:\s(.+)\n/
          Time.strptime($1, "%m/%d/%Y")
        end
      end

      property_not_supported :updated_on

      property_supported :expires_on do
        if content_for_scanner =~ /Record will expire on:\s(.+)\n/
          Time.strptime($1, "%m/%d/%Y")
        end
      end


      property_supported :nameservers do
        if content_for_scanner =~ /Domain Nameservers:\n((.+\n)+)\s+\n/
          $1.split("\n").map do |name|
            Parser::Nameserver.new(name: name.strip.downcase)
          end
        end
      end

      property_not_supported :registrant_contacts
      property_not_supported :admin_contacts
      property_not_supported :technical_contacts
      property_not_supported :registrar
    end
  end
end
