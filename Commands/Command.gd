extends Node

class_name Command

var initialized = false


@onready var current_unit: BaseUnit = get_parent().get_owner()

@export var description: String = "Base command"


func _init(battler: BaseUnit):
	current_unit = battler
	initialized = true


func execute():
	assert(initialized)
	print("%s missing overwrite of the execute method" % name)
	return false

func undo():
	assert(initialized)
	print("%s missing overwrite of the undo method" % name)
	return false


func can_use() -> bool:
	return true
