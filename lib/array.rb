module MoveByName
  def move(from, to)
    insert(to, delete_at(from))
  end
  
  def move_by_name(name, to)
    return self if index(name).nil? # return original array if name not found
    move(index(name), to)
  end
end

Array.send(:include, MoveByName)
WillPaginate::Collection.send(:include, MoveByName)
