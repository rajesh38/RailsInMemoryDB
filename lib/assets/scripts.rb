db = Database.new
db.create_table({name: "Emp", columns: [{name: "name", type: "string", required: true}, {name: "id", type: "int", required: false}]})

emp = db.tables["Emp"]
# check columns
emp.columns
emp.insert({"name": "Rajesh", id: 23})