extends Area3D

# Goal: Generates list of all units inside the attack area that can be attacked
class_name AttackArea

var array_of_possible_units_to_attack : Array[BaseUnit]
var owner_unit : BaseUnit

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("body_entered", on_body_entered)
	self.connect("body_exited", on_body_exited)
	self.owner_unit = get_parent()


func on_body_entered(body):
	if body is BaseUnit and body != owner_unit:
		array_of_possible_units_to_attack.append(body)
	#print(array_of_possible_units_to_attack.size())

func on_body_exited(body):
	array_of_possible_units_to_attack.remove_at(array_of_possible_units_to_attack.find(body))
	#print(array_of_possible_units_to_attack.size())

# THIS FUNCTION WILL BREAK IF THERES NOTHING IN THE ARRAY
# I have no idea how to solve this problem
func get_nearest_unit() -> BaseUnit:
	# check if this array is empty, or else the program will crash
	assert(!array_of_possible_units_to_attack.is_empty())
	var closest_enemy_unit : BaseUnit = array_of_possible_units_to_attack[0]
	for unit in array_of_possible_units_to_attack:
		if (unit.position - owner_unit.position).length() < (closest_enemy_unit.position - owner_unit.position).length():
			# probably don't want to keep killing an enemy thats already dead
			if !unit.is_dead():
				closest_enemy_unit = unit
	return closest_enemy_unit

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
