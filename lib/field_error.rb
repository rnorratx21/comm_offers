class FieldError
	def self.field_error_proc
		Proc.new do |html_tag, error_data|
			render_field_with_error html_tag, error_data
		end
	end

	def self.render_field_with_error(html_tag, error_data)
		if html_tag =~ /^<label/
			return wrap_label_tag_with_label_for_field_with_errors_span(html_tag)
		end

		model = error_data.object

		model_name = error_data.object_name
		attribute_name = error_data.method_name
		human_attribute_name = human_attribute_name(model, attribute_name)
		attribute_errors = model.errors.on(attribute_name.to_sym)

		field_with_errors_span = wrap_html_tag_with_field_with_errors_span(html_tag)
		model_error_span = model_error_span(model_name, attribute_name, human_attribute_name, attribute_errors)
		"#{field_with_errors_span} #{model_error_span}"
	end
	
	def self.human_attribute_name(model, attribute_name)
	  if model.class.respond_to?(:human_attribute_name)
	    model.class.human_attribute_name(attribute_name)
	  else
	    attribute_name
	  end
  end
	
	def self.model_error_span(model_name, attribute_name, human_attribute_name, attribute_errors)
		error_message_id = model_data_error_message_id(model_name, attribute_name)		
		error_message = error_message(attribute_name, human_attribute_name, attribute_errors)
		wrap_error_message_with_field_with_errors_message_span(error_message, error_message_id)
	end
	
	def self.wrap_html_tag_with_field_with_errors_span(html_tag)
		"<span class=\"field_with_errors\">#{html_tag}</span>"
	end

	def self.wrap_label_tag_with_label_for_field_with_errors_span(span_tag)
		"<span class=\"label_for_field_with_errors\">#{span_tag}</span>"
	end

	def self.model_data_error_message_id(model_name, attribute_name)
		"#{model_name}_#{attribute_name}_error_message"
	end

	def self.wrap_error_message_with_field_with_errors_message_span(error_message, html_id)
		"<span id=\"#{html_id}\" class=\"field_with_errors_message\">#{error_message}</span>"
	end
	
	def self.error_message(attribute_name, human_attribute_name, attribute_errors)
		joined_error_messages = attribute_errors.join(", ") if attribute_errors.is_a? Array
		"#{(joined_error_messages || attribute_errors)}"
	end
end