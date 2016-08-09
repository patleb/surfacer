module Surface
  module ViewHelper
    def alert(alert, message)
      css_click div(message, class: ['alert-message', alert])
    end

    def collapsible(label)
      css_click label do
        div(class: 'collapsible-content') do
          yield
        end
      end
    end

    def lightbox(source)
      css_click image_tag(source) do
        image_tag(source, class: 'thumbnail')
      end
    end

    def modal(label)
      css_click label do
        div(class: 'modal-content') do
          yield
        end
      end
    end

    def tooltip(text = nil, **html_options)
      if (tooltip_class = html_options.delete(:to))
        tooltip_class = "tooltip-#{tooltip_class}"
      else
        tooltip_class = "tooltip"
      end

      add_class(tooltip_class, html_options)

      html_options['data-tooltip'] = html_options.delete(:tip)

      if text
        span text, html_options
      else
        span html_options do
          yield
        end
      end
    end

    def tabs(labels, selected = nil)
      css_select(labels, selected) do |label_content, i|
        concat(div(class: 'tab-content') do
          yield label_content, i
        end)
      end
    end

    def nav
      ul do
        concat li(tabindex: 0, class: 'material-icons')

        yield
      end
    end

    def nav_dropdown(text)
      li tabindex: 0 do
        concat text
        concat(ul do
          yield
        end)
      end
    end

    def css_click(label_content)
      id = SecureRandom.hex

      concat %{
        <input type="checkbox" class="css-click" aria-hidden="true" id="#{id}">
      }.html_safe

      label = content_tag(:label, label_content, for: id, class: 'css-click-label', onclick: '')
      if block_given?
        concat label
        yield
      else
        label
      end
    end

    def css_select(labels, selected = nil)
      name = SecureRandom.hex

      labels.each_with_index do |label_content, i|
        id = "#{name}-#{i}"
        checked = (i == selected) ? 'checked' : ''

        concat %{
          <input type="radio" class="css-select" aria-hidden="true" name="#{name}" id="#{id}" #{checked}>
        }.html_safe

        label = content_tag(:label, label_content, for: id, class: 'css-select-label', onclick: '')
        if block_given?
          concat label
          yield label_content, i
        else
          label
        end
      end.reduce(&:<<)
    end

    # TODO #url-hash:target --> accordion
    # TODO span:focus ~ .class --> for when click outside the element to reset state (unlike the checkbox)
  end
end
