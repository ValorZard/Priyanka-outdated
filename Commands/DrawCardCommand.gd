extends Command

class_name DrawCardCommand

func _init(game_board : GameBoard):
	initialize(game_board)


func execute() -> bool:
	assert(initialized)
	print("%s missing overwrite of the execute method" % name)
	return false

func undo() -> bool:
	assert(initialized)
	print("%s missing overwrite of the undo method" % name)
	return false
