extends CharacterBody2D

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
	if (window_position_change != Vector2i(0,0)):
		print(window_position_change)
	last_window_position = current_window_position

func _physics_process(delta):
	
	velocity.x -= window_position_change.x
	velocity.y -= window_position_change.y
	
	# Add the gravity.
	velocity.y += gravity * delta
	
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		print(velocity)
		velocity = velocity.bounce(collision_info.get_normal()) * BOUNCE_FACTOR
		print(velocity)
	
