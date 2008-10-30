module Exceptional
  module Integration
    module Merb
      def self.included(mod)
        mod.class_eval do
          def base
            self.render_with_exceptional template_or_message, :layout=>false
          end

          def exception
            self.render_with_exceptional template_or_message, :layout=>false
          end

          private

          def template_or_message
            if File.exists?(Exceptional.application_root / 'app' / 'views' / 'exceptions' / 'internal_server_error.html.erb')
              :internal_server_error
            else
              '500 exception. Please customize this page by creating app/views/exceptions/internal_server_error.html.erb.'
            end
          end
        end
      end
      
      def render_with_exceptional(*opts)
        self.render_then_call(render(*opts)) { post_to_exceptional }
      end
      
      def post_to_exceptional
        exception = self.request.exceptions.first
        Exceptional.handle_merb(exception, request, params)
      end
    end
  end
end