class_name TrafficLight
extends Node2D


@export var yellow_duration : float = 3.0
var area : Area2D
var n : Sprite2D
var s : Sprite2D
var e : Sprite2D
var w : Sprite2D
var changing : bool
var ns_green : bool = true:
	get:
		return ns_green
	set(value):
		if changing:
			return
		_change_signals()
		# Has to be set in the setter to avoid infinite recursion
		ns_green = value
			

func _ready() -> void:
	area = get_node("%Area2D")
	area.body_entered.connect(_on_body_entered)
	n = get_node("%N")
	s = get_node("%S")
	e = get_node("%E")
	w = get_node("%W")
	n.self_modulate = Color.GREEN
	s.self_modulate = Color.GREEN
	e.self_modulate = Color.RED
	w.self_modulate = Color.RED
	
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		ns_green = !ns_green


func _on_body_entered(body : Node2D):
	if body is Car:
		if changing:
			body.going = false
			return
		#if ns_go, ew stop, ns ignore
		if ns_green and (body.travel_direction == Car.TRAVEL_DIRECTION.LEFT or body.travel_direction == Car.TRAVEL_DIRECTION.RIGHT):
			body.going = false
		#else, ns stop, ew ignore
		if not ns_green and (body.travel_direction == Car.TRAVEL_DIRECTION.UP or body.travel_direction == Car.TRAVEL_DIRECTION.DOWN):
			body.going = false
		

func _change_signals():
	if ns_green:
		n.self_modulate = Color.YELLOW
		s.self_modulate = Color.YELLOW
		# wait a few seconds
		changing = true
		await get_tree().create_timer(yellow_duration).timeout
		changing = false
		# yellow to red, red to green
		e.self_modulate = Color.GREEN
		w.self_modulate = Color.GREEN
		n.self_modulate = Color.RED
		s.self_modulate = Color.RED
		# TODO: set appropriate cars to going again
	else:
		e.self_modulate = Color.YELLOW
		w.self_modulate = Color.YELLOW
		# wait a few seconds
		changing = true
		await get_tree().create_timer(yellow_duration).timeout
		changing = false
		# yellow to red, red to green
		n.self_modulate = Color.GREEN
		s.self_modulate = Color.GREEN
		e.self_modulate = Color.RED
		w.self_modulate = Color.RED
		# TODO: set appropriate cars to going again
	
