class_name TrafficLight
extends Node2D


var area : Area2D


func _ready() -> void:
	area = get_node("%Area2D")
	area.body_entered.connect(_on_body_entered)
	

func _on_body_entered(body : Node2D):
	if body is Car:
		body.going = false
	
	
