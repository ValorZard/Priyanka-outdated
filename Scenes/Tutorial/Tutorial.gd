extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$BackToMenuButton.connect("button_up", go_back_to_menu)

func go_back_to_menu():
	get_tree().change_scene_to_file("res://Scenes/MainMenu/MainMenu.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
