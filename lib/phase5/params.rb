require 'uri'

module Phase5
  class Params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    #
    # You haven't done routing yet; but assume route params will be
    # passed in as a hash to `Params.new` as below:
   
    def initialize(req, route_params = {})
      @params = Hash.new
      parse_www_encoded_form(req.query_string) unless req.query_string.nil?
      parse_www_encoded_form(req.body) unless req.body.nil?
      @params.merge!(route_params)
    end

    def [](key)
      @params[key.to_s]
    end

    def to_s
      @params.to_json.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private
    # this should return deeply nested hash
    # argument format
    # user[address][street]=main&user[address][zip]=89436
    # should return
    # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
 
    def parse_www_encoded_form(www_encoded_form)

      # "cat%5Bname%5D=Steven+&cat%5Bowner%5D=Michaels"
      
      a = URI.decode_www_form(www_encoded_form)
      
      # [["cat[name]", "Steven "], ["cat[owner]", "Michaels"]]
      
      a.each do |key, value|
        # p "key #{key}"

        if parse_key(key).count == 1
          @params.merge!({ key => value })
        else
          
          keys = parse_key(key)
          current_hash = @params
          last = value
          until keys.count == 1
            current_key = keys.shift
            if current_hash[current_key]
              current_hash = current_hash[current_key]
              current_hash.merge!({keys.first => value}) if keys.count == 1
            else
              current_hash[current_key]= Hash.new
              current_hash = current_hash[current_key]
              current_hash.merge!({keys.first => value}) if keys.count == 1
            end
          end
        end
      end
    end

    # this should return an array
    #user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
      key.split(/\]\[|\[|\]/)
    end
  end
end
