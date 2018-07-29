extends Control

onready var go_button = $HostMenu/VBOX/GoButton
onready var cancel_button = $HostMenu/VBOX/CancelButton
onready var back_button = $HostMenu/VBOX/BackButton

func nextScene(sceneName):
	get_node("/root/global").delayNextScene(sceneName)

func _ready():
	go_button.connect("button_down",self,"nextScene",["HostJoin"])
	cancel_button.connect("button_down",self,"nextScene",["HostJoin"])
	back_button.connect("button_down",self,"nextScene",["HostJoin"])
