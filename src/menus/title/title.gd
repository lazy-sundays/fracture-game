extends MarginContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_start_button_pressed():
	start_game()
	
func start_game():
	get_tree().change_scene_to_file("res://src/scenes/main/main.tscn")

func _input(event):
	if event.is_action_pressed("Start Game"):
		start_game()
		
	elif event.is_action_pressed("Exit Game"):
		get_tree().quit()
