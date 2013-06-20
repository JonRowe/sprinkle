require 'erubis'
require 'digest/md5'

module Sprinkle::Package
  module Rendering
    extend ActiveSupport::Concern
    
    included do
      self.send :include, Helpers
    end
    
    def template(src, bound=binding)
      eruby = Erubis::Eruby.new(src)
      output = eruby.result(bound)
    rescue Object => e
      raise Sprinkle::Errors::TemplateError.new(e, src, bound)
    end
    
    def render(file)
      contents=File.read(expand_filename(file))
      template(contents)
    end
    
    # helper
    # def md5(s)
    #   Digest::MD5.hexdigest(s)
    # end
    
    module Helpers
      def md5(s)
        Digest::MD5.hexdigest(s)
      end
    end
    
    private 
    
    def expand_filename(n)
      return n.to_s if n.to_s.starts_with? "/"
      ["./templates/#{n}","./templates/#{n}.erb"].each do |f|
        return f if File.exist?(f)
      end
      raise "template file not found"
    end
    
  end
end