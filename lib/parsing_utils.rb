# Some classes useful for parsing matters (especially to select a parser based on a given mime type)
module ParsingUtils
  class ParsingUtilsError < StandardError; end
  class UnsupportedFormat < ParsingUtilsError; end
  # == Usage
  #   Parser.add(JSONParser, "application/json", "application/vnd.com.example.Object+json")
  #
  class Parser
    # FIXME: A bit ugly
    @@available_parsers = []
    class << self
      def available_parsers; @@available_parsers; end
      def add(parser, *mime_types)
        parser.dependencies
        parser.supported_mime_types = mime_types
        @@available_parsers << parser
        self
      end
      def select(mime_type)
        raise UnsupportedFormat, "The content_type cannot be nil." if mime_type.nil?
        parsers = available_parsers.select{|parser| parser.supported_mime_types.include?(mime_type)}
        if parsers.empty?
          raise UnsupportedFormat, "No parser found for '#{mime_type}' content type."
        else
          parsers.first
        end
      end
    end
  end

  class JSONParser
    class << self
      attr_accessor :supported_mime_types
      def dependencies
        require 'json'
      end
      def dump(object, options = {})
        options = options.dup
        case options.delete(:format)
        when :pretty
          JSON.pretty_generate object, options
        else
          JSON.generate(object, options)
        end
      end
      def load(object, options = {})
        JSON.parse(object, options)
      end
    end
  end

end