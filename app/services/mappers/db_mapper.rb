class Mappers::DbMapper
  def persistent_to_in_memory_obj(persistent_db:)
    db = in_memory_obj(db_name: persistent_db.name)
    return db if db
    ::Database.new(name: persistent_db.name, persistent: true)
  end

  def in_memory_to_persistent_obj(in_memory_obj:)
    Persistent::Database.find_by(name: in_memory_obj.name)
  end

  private

  def in_memory_obj(db_name:)
    db = DatabaseService.find_db(db_name: db_name, store: $IN_MEMORY_STORE_NAME)
    return db if db && db.is_a?(::Database)
  end
end