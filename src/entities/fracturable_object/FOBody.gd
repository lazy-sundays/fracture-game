extends RigidBody2D

@export var BOUNCE_FACTOR = .75

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") # default of 980
var WINDOW;
var last_window_position;
var window_position_change;
var current_window_position;

# Called when the node enters the scene tree for the first time.
func _ready():
	WINDOW = get_window();
	WINDOW.initial_position = WINDOW.WINDOW_INITIAL_POSITION_ABSOLUTE
	last_window_position = WINDOW.position
	current_window_position = WINDOW.position
	window_position_change = Vector2i(0,0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	current_window_position = WINDOW.position
	window_position_change = current_window_position - last_window_position
	last_window_position = current_window_position

func _physics_process(delta):
	
	apply_force(Vector2(-window_position_change.x, -window_position_change.y))
