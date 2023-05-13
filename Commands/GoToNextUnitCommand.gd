extends Command

class_name GoToNextUnitCommand

func _init(game_board : GameBoard):
	initialize(game_board)


func execute() -> bool:
	var has_started_new_round := false
	# clean up stuff with the current unit
	game_board.disable_current_unit()
	#go to next unit. if reached the end, go back to the start
	game_board.current_unit_index += 1
	# if we have reached the end, that means we have started a new round
	if game_board.current_unit_index >= game_board.units_in_initative_order.size():
		game_board.current_unit_index = 0
		has_started_new_round = true
	game_board.log_event(str("moving on to next unit : ", game_board.current_unit_index))
	# if the new unit we're on is dead, move on to the next one
	if game_board.get_current_unit().is_dead() and !game_board.check_if_one_side_won():
		execute()
	# if the game is already over, we can't exactly go to the next unit
	elif game_board.check_if_one_side_won():
		return false
	# set up new unit
	game_board.enable_current_unit()
	# if we had to loop around to find one, make sure to start a new round
	if has_started_new_round:
		game_board.round += 1
	return true

func undo() -> bool:
	var has_undone_old_round := false
	assert(initialized)
	# clean up stuff with the current unit
	game_board.disable_current_unit()
	#go to next unit. if reached the end, go back to the start
	game_board.current_unit_index -= 1
	if game_board.current_unit_index < 0:
		game_board.current_unit_index = game_board.units_in_initative_order.size() - 1
		has_undone_old_round = true
	game_board.log_event(str("moving on to previous unit : ", game_board.current_unit_index))
	# if the new unit we're on is dead, move on to the next one
	# we're assuming that at least one unit must still be alive
	if game_board.get_current_unit().is_dead():
		undo()
	# set up new unit
	game_board.enable_current_unit()
	if has_undone_old_round:
		game_board.round -= 1
	return true
