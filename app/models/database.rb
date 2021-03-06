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

  def create_persistent_db
    DatabaseService.create_persistent_db(db_name: name)
  end

  private
  def validate_table_entity_for_create(table_entity:)
    table_entity = table_entity.with_indifferent_access
    throw "Table: #{table_entity["name"]} already exists in DB: #{name}" if tables.key?(table_entity[:name])
  end
end
