module Exceptional
  module Integration
    module Merb
      def self.included(mod)
        mod.class_eval do
          def internal_server_error
            # These two variables are required by the default exception template
            @exception = self.params[:exception]
            @exception_name = @exception.name.split("_").map {|x| x.capitalize}.join(" ")
            self.render_and_notify :layout=>false
          end
        end
      end
    

      def render_with_exceptional(opts={})
        self.render_then_call(render(opts)) { post_to_exceptional }
      end

      def post_to_exceptional
        exception = self.params[:exception]
        request = self.request
        original_params = self.params[:original_params]
      
        Exceptional.handle(exception, self, request, original_params)
      end
    end
  end
end