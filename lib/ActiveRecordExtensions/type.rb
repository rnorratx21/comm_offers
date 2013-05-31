module Type
  
  def self.included(c)
    c.extend(ClassMethods)
    c.load_types if auto_load?
    c.after_save :update_type_cache
    c.after_destroy :update_type_cache
  end
  
  def self.auto_load?
    if ENV.include? 'AUTO_LOAD_TYPES'
      return ENV['AUTO_LOAD_TYPES'] == 'true'
    end
    true
  end
  
  module ClassMethods
    
    attr_accessor :types, :type_id_attribute, :type_name_attribute
    
    def [](id)
      case id
        when Integer then types.find{|t| t.type_id == id}
        when String, Symbol then const_get(to_const_name(id))
        else nil
      end
    end
    
    def create_types(types)
      types.each do |id, name|
        new_type = self.new
        new_type.send("#{type_id_attribute}=",id)
        new_type.send("#{type_name_attribute}=",name)
        new_type.save
      end
    end
    
    def options
      types.collect {|type| type.to_option }
    end
    
    def type_ids
      types.collect {|type| type.type_id }
    end

    def load_types
      logger.info "Loading types for #{self.name}"
      self.types = find(:all,:readonly=>true,:order=>type_id_attribute).freeze
      types.each do |type|
        const_set(to_const_name(type.type_name),type)
      end
    end

    def type_id_attribute
      @type_id_attribute ? @type_id_attribute : primary_key
    end
    
    def type_name_attribute
      @type_name_attribute ? @type_name_attribute : :name
    end
    
    def type_def(options)
      options.symbolize_keys!
      self.type_id_attribute = options[:id] if options.has_key? :id
      self.type_name_attribute = options[:name] if options.has_key? :name
      load_types
    end
    
    private
      #Turns a type name into a valid ruby constant which can contain only
      #letters, numbers and underscores. Any char that doesn't fit this
      #criteria is converted to an underscore. Consecutive underscores will
      #be squeezed into one. The result will be an upcased symbol.
      #Examples:
      # 1) Racoon => :RACOON
      # 2) Rabid Racoon => :RABID_RACOON
      # 3) Valentine's Day => :VALENTINE_S_DAY
      # 4) Food & Drink => :FOOD_DRINK
      def to_const_name(name)
const_name = name.to_s.gsub(/[^a-z0-9_]/i,'_').squeeze('_').upcase
        if const_name =~ /^[^a-z]/i
          const_name = "T_"+const_name
        end
        const_name.to_sym
      end
  end
  
  def type_id
    send(self.class.type_id_attribute)
  end
  
  def type_name
    send(self.class.type_name_attribute)
  end
  
  def const_name
    self.class.send(:to_const_name,type_name)
  end
  
  def to_i
    type_id
  end
  
  def to_param
    type_id
  end
  
  def to_option
    [type_name,type_id]
  end
  
  def ==(other)
    return false if other.nil?
    if self.class == other.class
      type_id == other.type_id
    else
      false
    end
  end
  
  def eql?(other)
    self == other
  end
  
  def ===(other)
    return false if other.nil?
    if self.class == other.class
      type_id == other.type_id
    elsif other.kind_of?(Integer)
      type_id == other
    else
      super(other)
    end
  end
  
  protected
    def update_type_cache
      self.class.load_types
    end
  
end
