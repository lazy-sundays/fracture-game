extends RigidBody2D

@export var fracture_threshold = 500
@export var max_speed = 3000

var happy_texture = preload("res://src/entities/fracturable_object/assets/happyegg.png")
var mid_texture = preload("res://src/entities/fracturable_object/assets/midegg.png")
var sad_texture = preload("res://src/entities/fracturable_object/assets/sadegg.png")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") # default of 980
var WINDOW;
var last_window_position;
var window_position_change;
var current_window_position;
var collision_pos = Vector2(0.0, 0.0)
var speed = Vector2(0, 0)
var is_resting;
var face_lock;

# Called when the node enters the scene tree for the first time.
func _ready():
	WINDOW = get_window();
	WINDOW.initial_position = WINDOW.WINDOW_INITIAL_POSITION_ABSOLUTE
	last_window_position = WINDOW.position
	current_window_position = WINDOW.position
	window_position_change = Vector2i(0,0)
	is_resting = false;
	update_face("happy")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	current_window_position = WINDOW.position
	window_position_change = current_window_position - last_window_position
	last_window_position = current_window_position
	
func _integrate_forces(state):
	# set maximum speed
	var mag = min(max_speed, state.linear_velocity.length())
	state.linear_velocity = state.linear_velocity.normalized() * mag
	
	# capture collision point
	if state.get_contact_count() > 0:
			collision_pos = to_local(state.get_contact_local_position(0))

func _physics_process(delta):
	speed = linear_velocity
	if (is_resting):
		apply_force(Vector2(window_position_change.x, window_position_change.y))
	else:
		apply_force(Vector2(-window_position_change.x, -window_position_change.y))
		
	
func is_in_circle(pt: Vector2, center: Vector2, radius) -> bool:
	return ((pt.x - center.x)**2 + (pt.y - center.y)**2 < radius**2)
	
func is_in_bounding_box(pt: Vector2, topLeft: Vector2, bottomRight: Vector2) -> bool:
	return (topLeft.x < pt.x && pt.x < bottomRight.x) && (topLeft.y > pt.y && pt.y > bottomRight.y)
	
func draw_fracture():
	# find point near center of egg to fracture to
	var w = max(%TopCapsule.shape.radius, %BottomCapsule.shape.radius)
	var h = max(%TopCapsule.shape.height / 2, %BottomCapsule.shape.height / 2)
	var x = randi_range(-w, w)
	var y = randi_range(-h, h)
	var inner_pt = Vector2(x, y)
	while (not is_in_circle(inner_pt, %CenterCircle.position, %CenterCircle.shape.radius)):
		x = randi_range(-w, w)
		y = randi_range(-h, h)
		inner_pt = Vector2(x, y)
	
	#initialize fracture settings
	var line = Line2D.new()
	line.default_color = Color(0, 0, 0)
	line.width = randf_range(1.5, 3.0)
	
	var num_fractures = randi_range(5, 15)
	
	# build the fracture path and draw
	line.add_point(collision_pos)
	for n in range(1, num_fractures):
		var a = float(n) / num_fractures
		var offset = randf_range(-1.0/num_fractures, 1.0/num_fractures) * collision_pos.distance_to(inner_pt)
		var px = ((1 - a) * collision_pos.x) + (a * x) + offset
		var py = ((1 - a) * collision_pos.y) + (a * y) + offset
		line.add_point(Vector2(px, py))
	line.add_point(inner_pt)
	
	add_child(line)
	
func update_face(mood):
	match(mood):
		"happy":
			%Sprite2D.texture = happy_texture
		"mid":
			%Sprite2D.texture = mid_texture
		"sad":
			%Sprite2D.texture = sad_texture
		_:
			%Sprite2D.texture = happy_texture

func reset_face():
	update_face("mid")

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	var object_hit = body.get_name()
	if (object_hit == "WallEdge"):
		is_resting = true;
	if (speed.length() > fracture_threshold):
		update_face("sad")
		%FaceTimer.start()
		
		draw_fracture()


func _on_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	var object_hit = body.get_name()
	if (object_hit == "WallEdge"):
		is_resting = false;
	if %FaceTimer.is_stopped():
		update_face("happy")

func _on_face_timer_timeout():
	reset_face()
