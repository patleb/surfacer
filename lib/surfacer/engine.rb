module Surfacer
  class Engine < ::Rails::Engine
    # Initialize engine dependencies on wrapper application
    Gem.loaded_specs["surfacer"].dependencies.each do |d|
      begin
        require d.name
      rescue LoadError => e
        # Put exceptions here.
      end
    end

    initializer "surfacer.configure_application" do
      ActiveSupport.on_load :action_view do
        ::ActionView::Helpers::FormBuilder.class_eval do
          module WithCurrentValue
            def range_field(attribute, **options)
              if options.delete(:current)
                options[:oninput] = options[:onchange] = "this.setAttribute('data-range', this.value)"
                options['data-range'] = options[:value] = object.send(attribute) || options[:value]
              end

              super
            end
          end
          prepend WithCurrentValue

          def toggle_field(attribute, **options)
            @template.add_class('css-toggle', options)

            @template.concat check_box(attribute, options)

            id = "#{@object_name}_#{attribute}"
            @template.content_tag(:label, '', for: id, class: 'css-toggle-label', 'aria-hidden' => true)
          end
        end
      end
    end
  end
end
