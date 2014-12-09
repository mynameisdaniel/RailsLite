require 'json'
require 'webrick'

module Phase7
  class Flash
    
    #flash is a special part of the session
    #flash values are stored and only available in the next request
    
    
    # find the cookie for this app
    # deserialize the cookie into a hash
    
    def initialize(req)
      req.cookies.each do | cookie |
        next unless cookie.name == '_rails_lite_app2'
        @cookie = JSON.parse(cookie.value)
      end
      @cookie ||= Hash.new
    end

    def [](key)
      if @cookie["counter"] == 0
        @cookie["counter"] +=1
        return @cookie[key]
      elsif @cookie["counter"] == 1
        temp = @cookie[key]
        @cookie["counter"] = 0
        @cookie[key] = nil
        temp
      end
    end

    def keep
      @cookie["counter"] = 0
    end

    def []=(key, val)
      @cookie[key] = val
      @cookie["counter"] = 0
    end

    # serialize the hash into json and save in a cookie
    # add to the responses cookies
    def store_flash(res)
      new_cookie = WEBrick::Cookie.new('_rails_lite_app2', @cookie.to_json)
      res.cookies << new_cookie
    end
  end
end
