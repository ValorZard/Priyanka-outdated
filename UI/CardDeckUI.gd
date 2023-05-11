extends HBoxContainer


# need to figure out how to generate cards, and then automatically set up signals when clicked
# also probably need a game state singleton or something. Will have to figure it out later.
# also need to code the grid and connect that to the cards
# https://www.gdquest.com/tutorial/godot/2d/tactical-rpg-movement/lessons/00.handling-grid-interactions/

class_name CardDeckUI

var count : int = 0

var game_board : GameBoard
var card_button_prefab := preload("res://UI/CardButton.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
#	for card_button in get_children():
#		if card_button is Button:
#			card_button.connect("button_up", _on_Card_Selected)
	pass

func set_game_board(game_board : GameBoard):
	self.game_board = game_board
#	for card_button in get_children():
#		if card_button is CardButton:
#			card_button.game_board = game_board

func is_hovered() -> bool:
	for card_button in get_children():
		if card_button is Button:
			if card_button.is_hovered():
				return true
	return false

func update_deck_ui(current_unit : BaseUnit):
	# clear all the current cards from the UI
	for child in get_children():
		self.remove_child(child)
	# now, add in add the cards for the unit
	for card_data in current_unit.card_hand:
		var card_button := card_button_prefab.instantiate()
		card_button.setup(card_data, game_board)
		add_child(card_button)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_Card_Selected():
	#print("hello ", count)
	#count += 1
	pass
