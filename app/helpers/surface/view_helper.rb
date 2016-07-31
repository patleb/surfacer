module Surface
  module ViewHelper
    def component(partial, locals = {}, &block)
      unless partial.include? '/'
        raise ArgumentError, 'partial full path name must be given or the partial is at the root level in views folder'
      end

      div class: partial.sub(/\/_/, '-').tr('/_', '-') do
        render(partial, locals, &block)
      end
    end

    def alert(alert, message)
      css_click class: 'alert-wrapper' do
        concat div(message, class: ['alert-message', alert])
      end
    end

    def collapsible(label, **html_options)
      css_click label, html_options do
        concat(div(class: 'collapsible-content') do
          yield
        end)
      end
    end

    def css_click(label = nil, **html_options)
      if label
        div html_options do
          id = SecureRandom.hex

          concat %{ <input type="checkbox" class="css-click" aria-hidden="true" id="#{id}"> }.html_safe
          concat content_tag(:label, label, for: id, class: 'css-click-label')

          yield
        end
      else
        if html_options.has_key? :class
          html_options[:class] << ' css-click-label'
        else
          html_options[:class] = 'css-click-label'
        end

        content_tag :label, html_options do
          concat %{ <input type="checkbox" class="css-click" aria-hidden="true"> }.html_safe

          yield
        end
      end
    end

    def div(*args, &block)
      options = args.extract_options!
      object_or_text = args.first

      case object_or_text
      when String, Symbol, nil
        if block
          content_tag :div, capture(&block), options
        else
          content_tag :div, object_or_text, options
        end
      else
        div_for object_or_text, options, &block
      end
    end
  end
end
