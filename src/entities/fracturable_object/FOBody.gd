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
	# find point near center of egg to fracture to
	var w = %CenterCapsule.shape.radius
	var h = %CenterCapsule.shape.height / 2
	var x = randi_range(-w, w)
	var y = randi_range(-h, h)
	var inner_pt = Vector2(x, y)
	
	#calculate fracture path
	var line = Line2D.new()
	line.default_color = Color(0, 0, 0)
	line.width = 1.0
	
	var num_fractures = randi_range(5, 20)
	
	line.add_point(collision_pos)
	for n in range(1, num_fractures):
		var a = float(n) / num_fractures
		var normal = (randf_range(-1.0 / num_fractures, 1.0 / num_fractures) * collision_pos.distance_to(inner_pt))
		var px = ((1 - a) * collision_pos.x) + (a * x) + normal
		var py = ((1 - a) * collision_pos.y) + (a * y) + normal
		if px < -w:
			px = -w;
		if px > w:
			px = w;
		if py < -h:
			py = -h;
		if py > h:
			py = h;
		print(collision_pos)
		print(Vector2(px, py))
		print(inner_pt)
		line.add_point(Vector2(px, py))
	line.add_point(inner_pt)
	add_child(line)

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	draw_fracture()
