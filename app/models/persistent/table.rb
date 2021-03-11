class Persistent::Table
  include Mongoid::Document

  belongs_to :database, class_name: "Persistent::Database"

  field :name, type: String
  field :columns, type: Array
end