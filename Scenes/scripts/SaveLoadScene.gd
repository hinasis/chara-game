extends Control

onready var save_button = $SaveLoadMenu/VBOX/SaveButton
onready var load_button = $SaveLoadMenu/VBOX/LoadButton
onready var back_button = $SaveLoadMenu/VBOX/BackButton

func nextScene(sceneName):
	get_node("/root/global").delayNextScene(sceneName)

func _ready():
	save_button.connect("button_down",self,"nextScene",["Save"])
	load_button.connect("button_down",self,"nextScene",["Load"])
	back_button.connect("button_down",self,"nextScene",["Main"])
