extends Node

class_name Command

var initialized = false

var game_board : GameBoard
var current_unit: BaseUnit

@export var description: String = "Base command"

func initialize(game_board : GameBoard):
	self.game_board = game_board
	self.current_unit = game_board.get_current_unit()
	initialized = true

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


func can_use() -> bool:
	return true
