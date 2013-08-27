require 'action_view/helpers/form_helper'

class Quizzy::Views::LabelledFormBuilder < ActionView::Helpers::FormBuilder
  (field_helpers.map(&:to_s) - %w(radio_button file_field check_box hidden_field fields_for) + %w(date_select)).each do |selector|
    src = <<-END_SRC
    def #{selector}(field, options = {})
      field = field.to_sym
      errors = @object.errors.to_hash
      errors = errors.merge(@object.all_translations_errors) if @object.respond_to?(:translated_attributes)

      @template.content_tag(:div, :class => "control-group \#{'error' if errors[field]}") do
        @template.concat(label_for_field(field, options))
        @template.concat(@template.content_tag(:div, :class => "controls") do
          @template.concat(super(field, options.except(:label, :required)))
          @template.concat(@template.content_tag(:span, errors[field].is_a?(Array) ? errors[field].first : errors[field], :class => "help-inline")) if errors[field]
        end)
      end
    end
    END_SRC
    class_eval src, __FILE__, __LINE__
  end

  def check_box(field, options = {})
    errors = @object.errors.to_hash
    errors = errors.merge(@object.all_translations_errors) if @object.respond_to?(:translated_attributes)

    @template.content_tag(:div, :class => "control-group \#{'error' if errors[field]}") do
      @template.concat(@template.content_tag(:div, :class => "controls") do
        @template.concat(label_for_field(field, options) do
          super(field, options.except(:label, :required))
        end)
        @template.concat(@template.content_tag(:span, errors[field].is_a?(Array) ? errors[field].first : errors[field], :class => "help-inline")) if errors[field]
      end)
    end
  end

  def select(field, choices, options={})
    field = field.to_sym
    errors = @object.errors.to_hash
    errors = errors.merge(@object.all_translations_errors) if @object.respond_to?(:translated_attributes)

    @template.content_tag(:div, :class => "control-group \#{'error' if errors[field]}") do
      @template.concat(label_for_field(field, options))
      @template.concat(@template.content_tag(:div, :class => "controls") do
        @template.concat(super(field, choices, options))
        @template.concat(@template.content_tag(:span, errors[field].is_a?(Array) ? errors[field].first : errors[field], :class => "help-inline")) if errors[field]
      end)
    end
  end

  # Returns a label tag for the given field
  def label_for_field(field, options = {})
    return ''.html_safe if options.delete(:no_label)
    text = ''
    text += yield if block_given?
    text += options[:label].is_a?(Symbol) ? l(options[:label]) : options[:label] if options[:label]
    text += @template.t(field.to_s, :scope => [:activerecord, :attributes, object_name.underscore]) unless options[:label]
    @template.content_tag(:label, text.html_safe,
                          :class => (block_given? ? "checkbox " : "control-label ").to_s + (@object && @object.errors[field].present? ? "error" : nil).to_s,
                          :for => (@object_name.to_s.gsub(/[\[\]]/,'_') + "_" + field.to_s).gsub(/__/, '_'))
  end

  def submit_button text
    @template.content_tag :div, :class => "control-group" do
      @template.concat(@template.content_tag(:div, :class => "controls") do
        @template.concat(@template.content_tag(:button, text, :class => "btn btn-primary", :type => "submit"))
      end)
    end
  end

  def buttons_save_cancel
    @template.content_tag :div, :class => "control-group" do
      @template.concat(@template.content_tag(:div, :class => "controls") do
        @template.concat(@template.content_tag(:button, "Save", :class => "btn btn-primary", :type => "submit"))
        @template.concat(' ')
        @template.concat(@template.content_tag(:button, "Cancel", :class => "btn cancel"))
      end)
    end
  end

  def buttons *bs
    @template.content_tag :div, :class => "control-group" do
      @template.concat(@template.content_tag(:div, :class => "controls") do
        bs.each do |button|
          if button.is_a?(Symbol)
            case button
            when :submit
              @template.concat(@template.content_tag(:button, "Submit", :class => "btn btn-primary", :type => "submit"))
            end
          end
        end
      end)
    end
  end
end
