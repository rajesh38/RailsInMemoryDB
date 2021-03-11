class Persistent::Database
  include Mongoid::Document
  # enable when need to store dynamic attributes
  # include Mongoid::Attributes::Dynamic

  has_many :tables, class_name: "Persistent::Table"
  field :name, type: String

  def create_table(table_config:)
    
  end
end