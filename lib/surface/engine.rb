module Surface
  class Engine < ::Rails::Engine
    initializer "surface.configure_application" do
      ActiveSupport.on_load :action_controller do
        ::ActionController::Base.class_eval do
          module WithFlashMessages
            def redirect_to(options = {}, response_status_and_flash = {})
              messages = response_status_and_flash[:flash]
              if messages && (messages.is_a?(Symbol) || messages.is_a?(Array))
                flashes = {}
                locals = response_status_and_flash[:locals]
                if messages.is_a?(Array)
                  messages.each do |key|
                    flashes[key] = flash_messages(key, locals)
                  end
                else
                  flashes[messages] = flash_messages(messages, locals)
                end
                response_status_and_flash.delete(:locals)
                response_status_and_flash[:flash] = flashes
              end
              super
            end
          end
          prepend WithFlashMessages

          private

          def flash!(*args)
            options = args.extract_options!
            args.each do |key|
              flash[key] = flash_messages(key, options[:locals])
            end
            options.except(:locals).each do |key, value|
              flash[key] = value
            end
          end

          def flash_now!(*args)
            options = args.extract_options!
            args.each do |key|
              flash.now[key] = flash_messages(key, options[:locals])
            end
            options.except(:locals).each do |key, value|
              flash.now[key] = value
            end
          end

          def flash_messages(key, *args)
            options = args.extract_options!

            i18n_key = "flash_messages.#{params[:controller]}.#{params[:action]}.#{key}"
            i18n_key.gsub!(/\//, ".")
            if I18n.exists?(i18n_key)
              return I18n.t(i18n_key, options)
            end

            i18n_key = "flash_messages.defaults.#{params[:action]}.#{key}"
            if I18n.exists?(i18n_key)
              return I18n.t(i18n_key, options)
            end

            i18n_key = "flash_messages.defaults.#{key}"
            I18n.t(i18n_key, options)
          end
        end
      end

      ActiveSupport.on_load :action_view do
        ::ActionView::Helpers::FormBuilder.class_eval do
          module WithCurrentValue
            def range_field(attribute, **options)
              if options.delete(:current)
                options[:oninput] = options[:onchange] = "this.setAttribute('data-value', this.value);"
                options['data-value'] = options[:value] = object.send(attribute) || options[:value]
              end

              super
            end
          end
          prepend WithCurrentValue

          def toggle_field(attribute, **options)
            if options.has_key? :class
              options[:class] << ' css-toggle'
            else
              options[:class] = 'css-toggle'
            end

            @template.concat check_box(attribute, options)

            id = "#{@object_name}_#{attribute}"
            @template.content_tag(:label, '', for: id, class: 'css-toggle-label', 'aria-hidden' => true)
          end
        end
      end
    end
  end
end
