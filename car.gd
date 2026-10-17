class_name Car
extends CharacterBody2D


enum TRAVEL_DIRECTION {
	UP, DOWN, LEFT, RIGHT
}

@export var max_speed : float = 50
@export var acceleration : float = 10
@export var deceleration : float = 25
@export var travel_direction : TRAVEL_DIRECTION = TRAVEL_DIRECTION.RIGHT
var direction : Vector2

var going : bool = true


func _ready() -> void:
	_initialize_direction()
	_choose_random_sprite()
	
	
# for testing
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		going = !going
	
	
func _physics_process(delta: float) -> void:
	if going:
		velocity = minf(max_speed, velocity.length() + acceleration * delta) * direction
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
	
