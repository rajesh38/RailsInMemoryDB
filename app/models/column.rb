class Column
  attr_accessor :name, :type, :required

  def self.construct_from_entity(column_entity)
    column = Column.new
    column.name = column_entity[:name]
    column.type = column_entity[:type]
    column.required = column_entity[:required]
    column
  end
end
