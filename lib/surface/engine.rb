module Surface
  class Engine < ::Rails::Engine
    initializer "surface.configure_application" do
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
