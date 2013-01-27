require 'json'

class Hash
  def inspect
    inner = map do |key, val|
      key_str = key.is_a?(Symbol) ? "#{key}: " : key.inspect + "=>"
      key_str + val.inspect
    end.join(", ")
    "{#{inner}}"
  end
end

module FakeAPI
  class JSONWriter
    def self.write(json)
      inner = json.inspect
      inner = remove_brackets_for_hash_argument(inner) if json.is_a?(Hash)
      "JSON(#{inner})"
    end

    def self.remove_brackets_for_hash_argument(str)
      str[1..-2]
    end
  end
end
