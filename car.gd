class_name Car
extends CharacterBody2D


@export var max_speed : float = 50
@export var acceleration : float = 10
@export var deceleration : float = 25
@export var travel_direction : Vector2 = Vector2.RIGHT

var going : bool = true


func _ready() -> void:
	pass
	
	
# for testing
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		going = !going
	
	
func _physics_process(delta: float) -> void:
	if going:
		velocity = minf(max_speed, velocity.length() + acceleration * delta) * travel_direction
	else:
		velocity = maxf(0, velocity.length() - deceleration * delta) * travel_direction
	
	#move_and_slide()
	move_and_collide(velocity * delta)
