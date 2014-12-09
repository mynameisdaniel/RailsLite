require_relative '../phase2/controller_base'
require 'active_support/inflector'
require 'active_support/core_ext'
require 'erb'

module Phase3
  class ControllerBase < Phase2::ControllerBase
    # use ERB and binding to evaluate templates
    # pass the rendered html to render_content

    # render views
    
    def render(template_name)

      controller_name = self.class.to_s.underscore
      template_name = template_name.to_s
      view_file_address = "views/#{controller_name}/#{template_name}.html.erb"

      unprocessed_erb = File.read(view_file_address)
      processed_erb = ERB.new(unprocessed_erb).result(binding)

      # calling binding makes instance variables available inside

      render_content(processed_erb, 'text/html')
    end
  end
end
