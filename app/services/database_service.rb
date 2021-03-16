class DatabaseService
  def self.create_db(db_name:, persistent: false)
    db = find_db(db_name: db_name)
    # if the persistent parameter is different from the existing object
    # then raise exception
    raise "Database: #{db_name} already exists with persistent: #{db.persistent}; Please use find_db instead." if db && persistent != db.persistent
    raise "Database: #{db_name} already exists; Please use find_db instead." if db
    # continuing DB creation if DB doesn't already exist
    LoggerService.new.add_log(log_mode: "debug", message: "Creating DB: #{db_name}, persistent: #{persistent}")
    db = Database.new(name: db_name, persistent: persistent)
    db_in_memory_store[db.name] = db
    create_persistent_db(db_name: db_name) if persistent
    return db
  end

  def self.find_db(db_name:, store: nil)
    unless store.nil?
      if store == $PERSISTENT_STORE_NAME
        return find_persistent_db(db_name: db_name)
      elsif store == $IN_MEMORY_STORE_NAME
        return db_in_memory_store[db_name]
      end
    end
    return db_in_memory_store[db_name] if db_in_memory_store[db_name]
    db = find_persistent_db(db_name: db_name)
    # checking if db exists
    if db
      LoggerService.new.add_log(log_mode: "debug", message: "Converting DB: #{db_name} from persistent to in memory")
      db = Mappers::DbMapper.new.persistent_to_in_memory_obj(persistent_db: db)
      db_in_memory_store[db.name] = db
    end
    db
  end

  def self.create_table(db_name:, table_entity:, persistent: false)
    db = find_db(db_name: db_name)
    table = db.create_table(table_entity: table_entity) if db
    if persistent
      persistent_db = find_persistent_db(db_name: db_name)
      raise "No persistent DB found with name: #{db_name}" unless persistent_db
      create_persistent_table(persistent_db: persistent_db, table_entity: table_entity)
    end
    return table
  end

  def self.drop_db(db_name:)
    drop_persistent_db(db_name: db_name)
    drop_in_memory_db(db_name: db_name) if find_db(db_name: db_name)
  end

  def self.drop_persistent_db(db_name:)
    db = find_persistent_db(db_name)
    db.destroy if db
    db_in_memory_store.delete(db_name)
    return true
  end

  def self.create_persistent_db(db_name:)
    db = Persistent::Database.new(name: db_name)
    db.save
  end

  def self.find_persistent_db(db_name:)
    Persistent::Database.find_by(name: db_name)
  end

  def self.create_persistent_table(persistent_db:, table_entity:)
    table_entity = table_entity.with_indifferent_access
    if check_if_table_exists(db_object: persistent_db, table_name: table_entity["name"])
      throw "Table: #{table_entity["name"]} already exists in DB: #{persistent_db.name}"
    end
    persistent_db.tables << Persistent::Table.new(table_entity)
  end

  def self.check_if_table_exists(db_object:, table_name:)
    case db_object.class
    when ::Database
      db_in_memory_store[db_name].present?
    when Persistent::Database
      db_object.tables.where(name: table_name).exists?
    end
  end

  def self.db_in_memory_store
    $DATA_STORE["databases"]
  end

  private_class_method :create_persistent_db,:find_persistent_db,:create_persistent_table,:check_if_table_exists,:db_in_memory_store
end