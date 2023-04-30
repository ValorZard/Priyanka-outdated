extends Command

class_name MovementCommand

var movement_direction : Vector3
var movement_distance : float 

func _init(battler: BaseUnit, movement_direction : Vector3, movement_distance : float):
	current_unit = battler
	initialized = true
	self.movement_direction = movement_direction
	self.movement_distance = movement_distance

func execute():
	current_unit.change_position(self.movement_direction, self.movement_distance)

func undo():
	current_unit.change_position(-self.movement_direction, self.movement_distance)
