class ColumnConstraintUtil

  VALIDATIONS = {
    "string" => {
      "max_length" => 20
    },
    "int" => {
      "min_value" => -1024,
      "max_value" => 1024
    }
  }

  def self.check_constraint(column_name:, column_type:, value:)
    case column_type
    when "string"
      max_length = VALIDATIONS[column_type]["max_length"]
      throw "#{column_name} should have length <= #{max_length}" if value.length > max_length
    when "int"
      min_value = VALIDATIONS[column_type]["min_value"]
      max_value = VALIDATIONS[column_type]["max_value"]
      if value < min_value || value > max_value
        throw "#{column_name} should be within range: #{min_value} to #{max_value}"
      end
    end
  end
end