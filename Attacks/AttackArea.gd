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

func sort_closest(unit1 : BaseUnit, unit2 : BaseUnit):
	if (unit1.global_position - owner_unit.global_position).length() < (unit2.global_position - owner_unit.global_position).length():
		return true
	return false

# get nearest units in array that aren't dead and are on the same team
func get_nearest_units() -> Array[BaseUnit]:
	# check if this array is empty, or else the program will crash
	assert(!array_of_possible_units_to_attack.is_empty())
	# remove all the units in the array that don't matter
	for unit in array_of_possible_units_to_attack:
		# remove dead units
		if unit.is_dead():
			array_of_possible_units_to_attack.erase(unit)
		# remove units on the same team
		if (owner_unit.is_in_group("enemy") and unit.is_in_group("enemy")) or (owner_unit.is_in_group("player") and unit.is_in_group("player")):
			array_of_possible_units_to_attack.erase(unit)
	array_of_possible_units_to_attack.sort_custom(sort_closest)
	return array_of_possible_units_to_attack

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
