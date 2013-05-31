require 'field_error'
ActionView::Base.field_error_proc = FieldError.field_error_proc
