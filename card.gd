extends Node2D
var faceup:bool = false
@export var cardid:int = 1
var backid = 0

func flip():
	faceup = not faceup
	check_facing()
	
func check_facing():
	match faceup:
		true:
			$AnimatedSprite2D.frame = cardid
		false:
			$AnimatedSprite2D.frame = backid
	

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if (event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT):
		flip()
