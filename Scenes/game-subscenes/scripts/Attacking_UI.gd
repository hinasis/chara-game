extends VBoxContainer

signal shaded_off

onready var label = $MarginContainer/MarginContainer/HBoxContainer/CenterContainer/Label
onready var img_1 = $MarginContainer/MarginContainer/HBoxContainer/TextureRect1
onready var img_2 = $MarginContainer/MarginContainer/HBoxContainer/TextureRect2

var opaque = Color(1.0,1.0,1.0,1.0)
var transparent = Color(1.0,1.0,1.0,0.0)

func _init():
	modulate = transparent

func _ready():
	#$Moving_arrows_1.material.set("shader_param/for_blue",Color(1.0,1.0,0.0,1.0))
	pass

func actionate(atk_card,def_card):
	var time = [0.0,0.5,1,0.75] # delay,time,delay,time
	var total_time = time[2]+time[3]
	$Tweener1.interpolate_property(self,"modulate",transparent,opaque,time[1],Tween.TRANS_LINEAR,Tween.EASE_IN,time[0])
	$Tweener2.interpolate_property(self,"modulate",opaque,transparent,time[3],Tween.TRANS_EXPO,Tween.EASE_IN,time[2])
	$Tweener2.connect("tween_completed",self,"on_animation_done",[],CONNECT_ONESHOT)
	$Tweener1.start()
	$Tweener2.start()
	label.text = ddbb.getByID(atk_card).names[0] + " attacks " + ddbb.getByID(def_card).names[0]
	img_1.texture = load(ddbb.getImagePathByID(atk_card,"atk"))
	img_2.texture = load(ddbb.getImagePathByID(def_card,"def"))

func on_animation_done(object,value):
	emit_signal("shaded_off")