extends Node2D

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
	music_player.play()
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(get_window().position)
	pass
