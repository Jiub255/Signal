class_name Car
extends CharacterBody2D


enum TRAVEL_DIRECTION {
	UP, DOWN, LEFT, RIGHT
}

@export var max_speed : float = 50
@export var acceleration : float = 10
@export var deceleration : float = 25
@export var travel_direction : TRAVEL_DIRECTION = TRAVEL_DIRECTION.RIGHT
@export var slow_follow_range : float = 10
@export var follow_distance_limit : float = 3
@export var follow_speed_multiplier : float = 1.2

var target_speed : float
var direction : Vector2
var going : bool = true
var car_in_front : Car

func _ready() -> void:
	_initialize_direction()
	_choose_random_sprite()
	_get_car_in_front()
	
	
# for testing
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		going = !going
	
	
func _physics_process(delta: float) -> void:
	if car_in_front == null:
		target_speed = max_speed
	else:
		var distance_to_car_ahead : float = (global_position - car_in_front.global_position).length()
		# if within range of car in front, target speed is car in front speed x 1.2 or something
		if distance_to_car_ahead > follow_distance_limit and distance_to_car_ahead < slow_follow_range:
			target_speed = car_in_front.velocity.length() * follow_speed_multiplier
		# if at follow limit, match speed exactly.
		elif distance_to_car_ahead <= follow_distance_limit:
			target_speed = car_in_front.velocity.length()
		# if not within range or there is no car in front, target speed is max speed.
		else:
			target_speed = max_speed
	
	if going:
		velocity = minf(target_speed, velocity.length() + acceleration * delta) * direction
	else:
		velocity = maxf(0, velocity.length() - deceleration * delta) * direction
	
	#move_and_slide()
	move_and_collide(velocity * delta)

	
func _initialize_direction():
	match travel_direction:
		TRAVEL_DIRECTION.RIGHT:
			direction = Vector2.RIGHT
			rotation_degrees = 0
		TRAVEL_DIRECTION.DOWN:
			direction = Vector2.DOWN
			rotation_degrees = 90
		TRAVEL_DIRECTION.UP:
			direction = Vector2.UP
			rotation_degrees = -90
		TRAVEL_DIRECTION.LEFT:
			direction = Vector2.LEFT
			rotation_degrees = 180
	
			
func _choose_random_sprite():
	var sprite : Sprite2D = get_node("Sprite2D") as Sprite2D
	sprite.frame = randi() % 16
	

func _get_car_in_front():
	var raycast : RayCast2D = get_node("RayCast2D") as RayCast2D
	var collider : Object = raycast.get_collider()
	if collider is Car:
		car_in_front = collider
		
		
