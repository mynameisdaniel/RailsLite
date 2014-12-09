require 'webrick'
require 'byebug'
require_relative '../lib/phase7/controller_base'

# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPRequest.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPResponse.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/Cookie.html


class MyController < Phase7::ControllerBase
  def show
    render :flash
  end
  
  def create
    flash["notice"] = params[:flash]
    render :flash
  end
end

server = WEBrick::HTTPServer.new(Port: 3000)
server.mount_proc('/') do |req, res|
  case [req.request_method, req.path]
  when ['GET', '/flash']
    MyController.new(req, res, {}).show
  when ['POST', '/flash']
    MyController.new(req, res, {}).create
  end
end

trap('INT') { server.shutdown }
server.start
