class Table
  attr_accessor :name, :columns, :records, :indices

  def initialize
    self.columns = {}
    self.records = []
    self.indices = {}
  end

  def self.construct_from_entity(table_entity)
    table = Table.new
    table.name = table_entity[:name]
    table_entity[:columns].each do |column_entity|
      table.columns[column_entity[:name]] = Column.construct_from_entity(column_entity)
    end
    table
  end

  def insert(record_hash)
    validate_record_hash(record_hash)
    records << record_hash
    build_index_for_record(record_hash)
  end

  def filter_by(column_name, value)
    records = @indices["#{column_name}_index"][value]
    puts records
  end

  def print_records
    puts records
  end

  private
  def validate_record_hash(record_hash)
    record_hash = record_hash.with_indifferent_access
    attrs = record_hash.keys
    # checking for invalid attributes
    if (extra_attrs = (attrs - columns.keys)).present?
      throw "Table: #{name} doesn't permit these attributes: #{extra_attrs.join(", ")}"
    end

    @required_attributes ||= self.columns.keys.select do |column_key|
      self.columns[column_key].required
    end

    @required_attributes.each do |attr|
      throw "Column: #{attr} is required" if record_hash[attr].blank?
    end

    record_hash.each do |attr, value|
      column_details = self.columns[attr]
      ::ColumnConstraintUtil.check_constraint(column_name: attr, column_type: column_details.type, value: value)
    end
  end

  def build_index_for_record(record_hash)
    unless @indices.present?
      self.columns.keys.each do |column_name|
        @indices["#{column_name}_index"] = {}
      end
    end
    record_hash.keys.each do |attr|
      @indices["#{attr}_index"][record_hash[attr]] ||= []
      @indices["#{attr}_index"][record_hash[attr]] << record_hash
    end
  end
end
