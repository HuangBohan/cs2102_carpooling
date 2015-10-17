module CompositePrimaryKeys
  class CompositeKeys
    def to_sym
      join('_').to_sym
    end
  end
end

class Array
  def to_sym
    join('_').to_sym
  end
end