module Surface
  module ViewHelper
    HTML_TAGS = Set.new(%i[
      div
      p
      label
    ])

=begin
  * IMPORTANT
  override of Kernel method `p`, but only in view context

  def p(*args, &block)
    ...
  end

  # https://github.com/activeadmin/arbre/blob/master/lib/arbre/html/html5_elements.rb#L16
  # might want to use --> tag = :p if tag == :para
=end

    HTML_TAGS.each do |tag|
      define_method tag do |*args, &block|
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

    def component(partial, locals = {}, &block)
      unless partial.include? '/'
        raise ArgumentError, 'partial full path name must be given or the partial is at the root level in views folder'
      end

      div class: partial.sub(/\/_/, '-').tr('/_', '-') do
        render(partial, locals, &block)
      end
    end

    def css_toggle(html_options = {})
      toggle = %{ <input type="checkbox" class="css-toggle" aria-hidden="true"> }.html_safe

      if block_given?
        label html_options do
          yield toggle
        end
      else
        toggle
      end
    end
  end
end
