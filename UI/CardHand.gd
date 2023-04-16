extends HBoxContainer


# need to figure out how to generate cards, and then automatically set up signals when clicked
# also probably need a game state singleton or something. Will have to figure it out later.
# also need to code the grid and connect that to the cards
# https://www.gdquest.com/tutorial/godot/2d/tactical-rpg-movement/lessons/00.handling-grid-interactions/

var count : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	for card in get_children():
		if card is Card:
			card.connect("button_up", _on_Card_Selected)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_Card_Selected():
	print("hello ", count)
	count += 1
	
