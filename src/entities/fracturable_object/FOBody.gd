extends RigidBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") # default of 980
var WINDOW;
var last_window_position;
var window_position_change;
var current_window_position;
var collision_pos = Vector2(0.0, 0.0)

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
	
func _integrate_forces(state):
	if state.get_contact_count() > 0:
		collision_pos = to_local(state.get_contact_local_position(0))

func _physics_process(delta):
	apply_force(Vector2(-window_position_change.x, -window_position_change.y))
	
func draw_fracture():
	var w = %CenterCapsule.shape.radius
	var h = %CenterCapsule.shape.height / 2
	var x = randi_range(-w, w)
	var y = randi_range(-h, h)
	
	var line = Line2D.new()
	line.default_color = Color(0, 0, 1)
	line.width = 5.0
	line.add_point(Vector2(x, y))
	line.add_point(collision_pos)
	add_child(line)

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	draw_fracture()
