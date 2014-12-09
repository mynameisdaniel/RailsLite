require_relative '../phase3/controller_base'
require_relative './session'

module Phase4
  class ControllerBase < Phase3::ControllerBase
    def redirect_to(url)
      super
      session.store_session(self.res)
      nil  
      #why
    end

    def render_content(content, type)
      super
      session.store_session(self.res)  
      nil
      #
    end

    # method exposing a `Session` object
    def session
      @session ||= Session.new(self.req)
    end
  end
end
