class Persistent::Database
  include Mongoid::Document

  attr_accessor :name, :tables
end