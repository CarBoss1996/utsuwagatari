module DataCardHelper
  include ActionDispatch::Routing::PolymorphicRoutes

  def card_value(object, method, options = {})
    DataCardItem.new(object, method, options).value.html_safe
  end
  def card_item(object, method, options = {})
    item = DataCardItem.new(object, method, options)

    formatter = options.delete(:formatter) || :list_group_item
    case formatter
    when :list_group_item
      content_tag(:div, class: "list-group-item card-item") do
        tag.div(class: "row") do
          if block_given?
            tag.label(item.label, class: "col-sm-3 card-item-label") +
            tag.div(class: "col-sm-9") do
              yield
            end
          else
            tag.label(item.label, class: "col-sm-3 card-item-label") +
            tag.div(item.value.html_safe, class: "col-sm-9")
          end
        end
      end
    when :vertical
      value_class = [ "card-item-value" ]
      value_class << "card-item-value-#{options[:as] || 'default'}"
      content_tag(:div, class: "card-item") do
        if block_given?
          content_tag(:div, item.label, class: "card-item-label mb-1") +
          tag.div(class: value_class.join(" ")) do
            yield
          end
        else
          content_tag(:div, item.label, class: "card-item-label mb-1") +
          content_tag(:div, item.value.html_safe, class: value_class.join(" "))
        end
      end
    when :horizontal
      content_tag(:div, class: "row card-item-row") do
        if block_given?
          content_tag(:label, item.label, class: "control-label card-item-label col-sm-3") +
          tag.div(class: "col-sm-9 card-item-value #{options[:class]}") do
            yield
          end
        else
          content_tag(:label, item.label, class: "control-label card-item-label col-sm-3") +
          content_tag(:div, item.value.html_safe, class: "col-sm-9 card-item-value #{options[:class]}")
        end
      end
    when :table
      content_tag(:th, item.label) + content_tag(:td, item.value.html_safe)
    when :dl
      if block_given?
        content_tag(:dt, item.label, class: "") +
        tag.dd(class: "#{options[:class]}") do
          yield
        end
      else
        content_tag(:dl, class: "") do
          content_tag(:dt, item.label, class: "") +
          content_tag(:dd, item.value.html_safe, class: "#{options[:class]}")
        end
      end
    when :none
      item.value.html_safe
    end
  end

  class DataCardItem
    attr_accessor :label
    attr_accessor :value
    include ActionView::Helpers
    include ApplicationHelper

    def initialize(object, method, options = {})
      @options = options
      if object.respond_to?(method)
        value = object.send(method)

        if value.present? || !value.nil?
          case @options[:as]
          when :email
            value = mail_to(value, value, reply_to: Settings.support_address).html_safe
          when :password
            value = "＊" * value.size
          when :date
            value = Date.parse(value) unless value.is_a?(Date)
            value = I18n.l(value, format: (@options[:date_format].presence || :long))
          when :datetime
            value = Time.parse(value) unless value.is_a?(Time)
            value = I18n.l(value, format: :medium)
          when :time
            value = Time.parse(value) unless value.is_a?(Time)
            value = I18n.l(value, format: (@options[:time_format].presence || :short))
          when :date_range
            _date_format = options[:date_format].presence || :long
            value = value.map { |v|I18n.l(v, format: _date_format) }.join("〜")
          when :time_range
            value = value.map { |v|I18n.l(v, format: :micro) }.join("〜")
          when :currency
            value = number_to_currency(value)
          when :delimiter
            value = number_with_delimiter(value)
          when :text
            value = simple_format(value)
          when :json
            value = tag.pre(JSON.pretty_generate(value))
          when :codemirror_json
            dom_id = SecureRandom.hex
            js_src = <<-END_SRC.strip_heredoc
              var jsEditor = CodeMirror.fromTextArea(document.getElementById('#{dom_id}'), {
                  mode: 'application/ld+json',
                  theme: 'yeti',
                  lineNumbers: true,
                  readOnly: true,
                  indentUnit: 40,
                  indentWithTabs: false,
                  electricChars: true,
                  withBrackets: true,
                  json: true
              });
            END_SRC
            value = [
                      text_area_tag(dom_id, JSON.pretty_generate(value), class: "codemirror-json form-control", rows: 10),
                      javascript_tag(js_src)
                    ].join.html_safe
          when :boolean
            value = (value ? content_tag(:i, "", class: "bi-check-circle") : content_tag(:i, "", class: "fa fa-square-o"))
          when :enum
            if object.send(method).is_a?(Enumerize::Set)
              value = object.send(method).send(:texts).join("、")
            else
              value = object.send("#{method}_text")
            end
          when :boolean_enum
            if value
              value = tag.span(options[:texts].first, class: "badge badge-warning")
            else
              value = tag.span(options[:texts].last, class: "badge badge-info")
            end
          when :array
            value = value.join("、")
          when :map
            value = object.map { |v|v.send(method) }.join("、")

          when :check
            if value
              value = '<span class="text-success"><i class="bi bi-check-circle-fill"></i></span>'.html_safe
            else
              value = '<span class="text-danger"><i class="bi bi-dash-circle-fill"></i></span>'.html_safe
            end
          when :belongs_to
            _label_method = options[:label_method].presence || :name
            value = object.send(method).send(_label_method)
          when :image_url
            value = tag.img(src: value)
          when :preview
            value = image_tag(@options.delete(:image_path), @options).html_safe
          when :coop_number
            value = value.rjust(12)
            value = [ value[0..3], value[4..7], value[8..11] ].join("-")
          when :stock_item_scope
            case value
            when "coop"
              value = tag.span("会員商品", class: "badge badge-success badge-lg")
            when "rengo"
              value = tag.span("連合商品", class: "badge badge-warning badge-lg")
            end
          when :pass_type
            case value
            when "yet"
              value = tag.span(value.text, class: "badge badge-warning")
            when "done"
              value = tag.span(value.text, class: "badge badge-success")
            end
          when :user_type
            case value
            when "child"
              value = tag.span(value.text, class: "badge badge-info")
            when "parent"
              value = tag.span(value.text, class: "badge badge-danger")
            end
          when :proxy_text
            if value
              value = tag.span("来場（代行）", class: "badge badge-warning")
            else
              value = tag.span("WEB", class: "badge badge-success")
            end
          when :no_tax
            if value
              value = "\u975E\u8AB2\u7A0E"
            else
              value = "\u7A0E\u8FBC"
            end
          when :active
            if value
              value = tag.span(class: "badge badge-active") do
                tag.span(class: "content") do
                  tag.i(class: "bi bi-check-circle-fill") + "有効"
                end
              end
            else
              value = tag.span(class: "badge badge-void") do
                tag.span(class: "content") do
                  tag.i(class: "bi bi-dash-circle-fill") + "無効"
                end
              end
            end
          when :medical
            if value
              value = tag.span(class: "badge badge-active") do
                tag.span(class: "content") do
                  tag.i(class: "bi bi-check-circle-fill") + "必要"
                end
              end
            else
              value = tag.span(class: "badge badge-void") do
                tag.span(class: "content") do
                  tag.i(class: "bi bi-dash-circle-fill") + "不要"
                end
              end
            end
          when :closed
            if value
              value = tag.span(class: "badge badge-void") do
                tag.span(class: "content") do
                  tag.i(class: "bi bi-dash-circle-fill") + "休業"
                end
              end
            else
              value = tag.span(class: "badge badge-active") do
                tag.span(class: "content") do
                  tag.i(class: "bi bi-check-circle-fill") + "営業"
                end
              end
            end
          when :emails
            value = (value.presence || {}).map { |v| v[:email] }.join("<br>").html_safe
          end
        else
          value = nil
        end
      elsif (options[:as].presence || "") == :map
        value = object.map { |v|v.send(method) }.join("、")
      else
        value = nil
      end
      if value.present?
        @value = [
          options[:prefix],
          value,
          options[:suffix]
        ].compact_blank.join
        if options[:ruby]
          @value = tag.small(options[:ruby], class: "text-info") + tag.br + @value
        end
        @value.html_safe
      else
        @value = "−−−−−"
      end
      if options[:cancel]
        @value = [ tag.del(@value, class: "text-danger"), tag.span("\u30AD\u30E3\u30F3\u30BB\u30EB\u3055\u308C\u3066\u3044\u307E\u3059", class: "text-danger") ].join("<br>").html_safe
      end
      if options[:link].present?
        @value = link_to(@value, options[:link], (options[:link_options] || {}))
      end

      label = options.delete(:label)
      if options[:as] == :map
        label ||= object.first.try(:human_attribute_name, method)
      elsif options[:as] == :belongs_to
        if (_label_method = options[:label_method]).present?
          label ||= object.send(method).class.human_attribute_name(_label_method) rescue nil
        else
          label ||= method.to_s.classify.constantize.model_name.human
        end
      else
        label ||= object.class.try(:human_attribute_name, method)
      end
      @label = label
    end
  end
end
