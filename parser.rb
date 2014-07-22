def load_config(file_path, overrides=[])
  Parser.new.parse(file_path, overrides)
end

class StructHash < Hash
  def method_missing(meth, *args, &block)
    if has_key?(meth)
      self[meth]
    else
      # 'super' instead of 'nil' here would return a NoMethodError if there's no meth
      nil  # this is the behavior we want
    end
  end
end

class Parser
  def parse(file_path, overrides=[])
    hash = StructHash.new

    file = IO.readlines(file_path)

    group = nil

    file.each do |line|
      # ignore anything from ; to the end of line
      line = line.sub(/;.*$/, '').chomp

      case line
      when '' # skip comments
        next
      when /^(?:\s*)\[(\w+)\](?:\s*)$/ # this is for getting :group from [group]
        group = $1.to_sym
        hash[group] = StructHash.new
      when /^(.+?)\s*=\s*(.+)/ # assign key=value
        # add to hash of hashes
        key, value = $1, $2

        # manipulate the value before putting it in the hash
        case value
        when /^\d+$/; value = value.to_i
        when /^"(.+)"$/; value = $1
        when /,/; value = value.split(',')
        when 'yes', 'true', '1' ; value = true
        when 'no', 'false', '0' ; value = false
        end

        # this is for the overrides "path<override>"
        case key
        when /^(.+)<(.+?)>$/
          key, override = $1, $2 # assign path, override
          if overrides.find {|o| o.to_s == override }
            hash[group][key.to_sym] = value
          end
        else
          hash[group][key.to_sym] = value
        end
      end
    end

    hash

  end
end

CONFIG = load_config('./hello.ini', ["ubuntu", :production])

require 'pp'

pp CONFIG.common.paid_users_size_limit
pp CONFIG.ftp.name
pp CONFIG.http.params
pp CONFIG.ftp.lastname
pp CONFIG.ftp.enabled
pp CONFIG.ftp[:path]
pp CONFIG.ftp
