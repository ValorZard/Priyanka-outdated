extends Node

func execute(character_unit : CharacterUnit, movement_direction : Vector3, movement_distance : float):
	# don't allow character to move more than max movement radius
	if(movement_distance > character_unit.MAX_MOVEMENT_RADIUS):
		movement_distance = character_unit.MAX_MOVEMENT_RADIUS
	character_unit.position += movement_direction * movement_distance
