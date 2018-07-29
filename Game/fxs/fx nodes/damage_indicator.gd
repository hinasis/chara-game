extends Control

signal done

onready var damage_label = $"damage label"

var scale_value = Vector2(1.2,1.2)
var offset_value = Vector2(-40,-40)
var trans_type = Tween.TRANS_LINEAR
var ease_type = Tween.EASE_IN_OUT
var duration = 1.0
var delay = 0.0
var damage = 0

var random_direction = false

func _ready():
	setup_tweener()
	damage_label.text = str(damage)
	$tweener.connect("tween_completed",self,"on_tween_complete")
	play()

func setup_tweener():
	if random_direction:
		randomize()
		var random_x = abs(sin(randi())) * (randi() % 50)
		offset_value = Vector2(-random_x,offset_value.y)
	
	$tweener.interpolate_property(self,"rect_scale",self.rect_scale,scale_value,duration,trans_type,ease_type,delay)
	$tweener.interpolate_property(self,"rect_position",self.rect_position,self.rect_position+offset_value,duration,trans_type,ease_type,delay)
	$tweener.interpolate_property(self,"modulate",self.modulate,Color(1,1,1,0),duration,trans_type,ease_type,delay)

func play():
	$tweener.start()

func on_tween_complete(obj,key):
	emit_signal("done")