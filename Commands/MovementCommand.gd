extends Command

class_name MovementCommand

var movement_direction : Vector3
var movement_distance : float 

func _init(game_board : GameBoard, movement_direction : Vector3, movement_distance : float):
	initialize(game_board)
	self.movement_direction = movement_direction
	self.movement_distance = movement_distance

func execute():
	current_unit.change_position(self.movement_direction, self.movement_distance)
	game_board.log_event(str("execute! direction: ", self.movement_direction, ", distance: ", self.movement_distance))
	return true

func undo():
	current_unit.change_position(-self.movement_direction, self.movement_distance)
	game_board.log_event(str("execute! undo: ", self.movement_direction, ", distance: ", self.movement_distance))
	return true
