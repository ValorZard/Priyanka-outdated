extends Command

class_name GoToNextUnitCommand

func _init(game_board : GameBoard):
	initialize(game_board)


func execute() -> bool:
	# clean up stuff with the current unit
	game_board.disable_current_unit()
	#go to next unit. if reached the end, go back to the start
	game_board.current_unit_index += 1
	if game_board.current_unit_index >= game_board.units_in_initative_order.size():
		game_board.current_unit_index = 0
	# if the new unit we're on is dead, move on to the next one
	if game_board.get_current_unit().is_dead() and !game_board.check_if_one_side_won():
		execute()
	# if the game is already over, we can't exactly go to the next unit
	elif game_board.check_if_one_side_won():
		return false
	# set up new unit
	game_board.enable_current_unit()
	game_board.log_event(str("moving on to next unit : ", game_board.current_unit_index))
	return true

func undo() -> bool:
	assert(initialized)
	# clean up stuff with the current unit
	game_board.disable_current_unit()
	#go to next unit. if reached the end, go back to the start
	game_board.current_unit_index -= 1
	if game_board.current_unit_index < 0:
		game_board.current_unit_index = game_board.units_in_initative_order.size() - 1
	# if the new unit we're on is dead, move on to the next one
	# we're assuming that at least one unit must still be alive
	if game_board.get_current_unit().is_dead():
		undo()
	# set up new unit
	game_board.enable_current_unit()
	game_board.log_event(str("moving on to previous unit : ", game_board.current_unit_index))
	return true
