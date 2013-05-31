class Hash #:nodoc:
  # Returns a new hash with only the given keys.
  def only(*keys)
    clone.only!(*keys)
  end

  # Replaces the hash with only the given keys.
  def only!(*keys)
    keys.flatten!
    keys.map! { |key| convert_key(key) } if respond_to?(:convert_key)
    reject { |key, val| !keys.include?(key) }
  end

  def rename_key!(old_key, new_key)
    self[new_key] = self.delete(old_key)
    return self
  end
  
  def with(overrides)
    merge(overrides)
  end
  
end
