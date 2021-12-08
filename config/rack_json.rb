# frozen_string_literal: true

module Rack
  class JSON
    def parse_json(body)
      MultiJson.load(body)
    end

    def json_parser_error_class
      ::MultiJson::ParseError
    end

    def on_parse_error(_error_msg)
      [400,
       { 'content-type' => 'application/json' },
       ['{"error": "Could not parse, check headers and body format"}']]
    end
  end
end
