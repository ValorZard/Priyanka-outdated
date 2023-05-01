extends Command

class_name MovementCommand

var movement_direction : Vector3
var movement_distance : float 

func _init(current_unit: BaseUnit, movement_direction : Vector3, movement_distance : float):
	self.current_unit = current_unit
	initialized = true
	self.movement_direction = movement_direction
	self.movement_distance = movement_distance

func execute():
	current_unit.change_position(self.movement_direction, self.movement_distance)
	print("execute! direction: ", self.movement_direction, ", distance: ", self.movement_distance)

func undo():
	current_unit.change_position(-self.movement_direction, self.movement_distance)
	print("execute! undo: ", self.movement_direction, ", distance: ", self.movement_distance)
