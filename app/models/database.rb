class Database
  attr_accessor :name, :persistent, :tables

  def initialize(name:, persistent: false)
    self.name = name
    self.persistent = persistent
    self.tables = {}
  end

  def create_table(table_entity:)
    validate_table_entity_for_create(table_entity: table_entity)
    table = Table.construct_from_entity(table_entity: table_entity)
    tables[table_entity[:name]] = table
    table
  end

  def drop_table(table_name:)
    throw "Table not found" unless tables.key?(table_name)
    tables.delete(table_name)
  end

  # public method to get tables in the db
  def get_tables
    tables
  end

  private
  def validate_table_entity_for_create(table_entity:)
    throw "Table already exists" if tables.key?(table_entity[:name])
  end
end
