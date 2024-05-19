extends Node2D

@export var enable_music = true

var music_player;
# Called when the node enters the scene tree for the first time.
func _ready():
	#print_tree_pretty()
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	var music = load("res://src/globals/assets/panic.mp3")
	music.set_loop(true)
	music_player.set_stream(music)
	music_player.volume_db = -15.0
	if enable_music:
		music_player.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(get_window().position)
	pass
	
func _input(event):
	if event.is_action_pressed("Toggle Music"):
		enable_music = !enable_music
		if music_player.playing:
			music_player.stop()
		else:
			music_player.play()
		
	elif event.is_action_pressed("Exit Game"):
		get_tree().quit()
