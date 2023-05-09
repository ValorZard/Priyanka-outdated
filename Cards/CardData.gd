extends Resource

class_name CardData

@export var attack_point_cost: int
@export var description : String

# Make sure that every parameter has a default value.
# Otherwise, there will be problems with creating and editing
# your resource via the inspector.
func _init(attack_point_cost = 0, description = "lorem ipsum"):
	self.attack_point_cost = attack_point_cost
	self.description = description
