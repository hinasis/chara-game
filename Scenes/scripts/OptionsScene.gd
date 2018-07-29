extends Control

onready var title_button = $OptionsMenu/VBOX/TitleButton
onready var exit_button = $OptionsMenu/VBOX/ExitButton
onready var back_button = $OptionsMenu/VBOX/BackButton

func nextScene(sceneName):
	get_node("/root/global").delayNextScene(sceneName)

func _ready():
	title_button.connect("button_down",self,"nextScene",["Title"])
	exit_button.connect("button_down",self,"nextScene",["Exit"])
	back_button.connect("button_down",self,"nextScene",["Main"])
