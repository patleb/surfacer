module Surface
  class FormBuilder < ::ActionView::Helpers::FormBuilder
    def range_field(attribute, **options)
      if options.delete(:current)
        options[:oninput] = options[:onchange] = "this.setAttribute('data-value', this.value)"
        options['data-value'] = options[:value] = object.send(attribute) || options.delete(:value)
      end

      super
    end

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

  module FormHelper
    def surface_form_for(record, options = {}, &block)
      options[:builder] = Surface::FormBuilder

      form_for(record, options, &block)
    end
  end
end
