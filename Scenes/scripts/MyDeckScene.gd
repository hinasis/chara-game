extends Control

onready var back_button = $BackButtonArea/BackButton

func nextScene(sceneName):
	get_node("/root/global").delayNextScene(sceneName)

func _ready():
	back_button.connect("button_down",self,"nextScene",["Main"])
