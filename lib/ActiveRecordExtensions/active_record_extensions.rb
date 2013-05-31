


module ActiveRecord
  module Associations
    module ClassMethods
      def act_as_type(options={})
        include Type
        unless options.empty?
          type_def options
        end
      end
      
      def belongs_to_type(name, options={})
        options.symbolize_keys!
        #Create standard belongs_to association
        belongs_to name, options
        #Override the object getter created by the belongs_to association so that it loads the
        #type instance from the cache accessible from the type class instead of going to the database
        type_class = (options[:class_name]||name).to_s.camelize.constantize
        fk = options[:foreign_key] || "#{name}_#{type_class.type_id_attribute}"
        define_method(name.to_sym) do
          type_class[self.send(fk)]
        end
      end
    end
  end
end

