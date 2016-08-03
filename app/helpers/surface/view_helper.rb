module Surface
  module ViewHelper
    def body_class(*args)
      template = controller.template_virtual_path.tr('/_','-')
      css_classes = [
        template,
        I18n.locale,
      ]
      css_classes.concat(args) if args.any?
      css_classes.compact.join(' ')
    end

    def component(partial, locals = {}, &block)
      unless partial.include? '/'
        raise ArgumentError, 'partial full path name must be given or the partial is at the root level in views folder'
      end

      css_classes = [partial.sub(/\/_/, '-').tr('/_', '-')]
      css_classes << locals.delete(:class)

      div class: css_classes do
        render(partial, locals, &block)
      end
    end

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

    def div(*args, &block)
      _with_tag :div, *args, &block
    end

    def span(*args, &block)
      _with_tag :span, *args, &block
    end

    def add_class(value, html_options)
      with_space = " " << value
      if html_options.has_key? :class
        html_options[:class] << with_space
      else
        html_options[:class] = with_space
      end
    end

    private

    def _with_tag(tag, *args, &block)
      options = args.extract_options!
      object_or_text = args.first

      case object_or_text
      when String, Symbol, nil
        if block
          content_tag tag, capture(&block), options
        else
          content_tag tag, object_or_text, options
        end
      else
        content_tag_for tag, object_or_text, options, &block
      end
    end
  end
end
