extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/PlayButton.connect("button_up", play_game)
	$VBoxContainer/TutorialButton.connect("button_up", go_to_tutorial)
	$VBoxContainer/QuitButton.connect("button_up", quit_game)

func play_game():
	get_tree().change_scene_to_file("res://Scenes/test_scene.tscn")

func go_to_tutorial():
	get_tree().change_scene_to_file("res://Scenes/Tutorial/Tutorial.tscn")

# https://docs.godotengine.org/en/stable/tutorials/inputs/handling_quit_requests.html
func quit_game():
	get_tree().get_root().propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
