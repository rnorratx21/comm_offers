# reference material
# http://st-on-it.blogspot.com/2009/07/fixing-rails-forms-builder.html
# http://apidock.com/rails/ActionView/Helpers/TagHelper/content_tag

module FormHelper
  def self.included(base)
    ActionView::Base.default_form_builder = FormBuilder
  end

  class FormBuilder < ActionView::Helpers::FormBuilder	
		def model_label(method, text=nil, options = {})
			options[:class] ||= "model_label"
		  @template.content_tag(:label, label(method, text, options))
		end

		def field_label(method, options={})
			text = options.delete :text
			text = options.delete :label if options[:label]
			required = options.delete :required
			hint = options.delete :hint
		
			required_markup = " <span class=\"required\">*</span>"
			hint_markup	= " <span class=\"hint\">#{hint}</span>"
			
			"#{model_label(method, text)}#{required_markup if required}#{hint_markup if hint}"
		end

		def labeled_text_field(method, options={})
			field_paragraph(
				field_label(method, options) +
				text_field(method, options)
			)
		end
		
		def labeled_text_area(method, options={})
		  field_paragraph(
		    field_label(method, options) +
		    text_area(method, options)
		  )
		end

		def labeled_select_field(method, selections, options={})
			field_paragraph(
				field_label(method, options) +
				select(method, selections)
			)			
		end
		
		def field_paragraph(content)
			@template.content_tag :p, content, :class => "field"
		end
  end
end