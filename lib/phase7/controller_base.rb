require_relative '../phase6/controller_base'
require_relative './flash'


module Phase7
  class ControllerBase < Phase5::ControllerBase
    
    def redirect_to(url)
      super
      flash.store_flash(self.res)  
      nil  
      #why
    end
    
    def render_content(content, type)
      super
      flash.store_flash(self.res)  
      nil
      #
    end
    
    def flash
      @flash ||= Flash.new(self.req)
    end
    
  end
end
