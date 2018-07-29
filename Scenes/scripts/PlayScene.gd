extends Control

onready var ai_button = $PlayMenu/VBOX/AIButton
onready var campain_button = $PlayMenu/VBOX/CampainButton
onready var back_button = $PlayMenu/VBOX/BackButton

func nextScene(sceneName):
	get_node("/root/global").delayNextScene(sceneName)

func _ready():
	ai_button.connect("button_down",self,"nextScene",["Main"])
	campain_button.connect("button_down",self,"nextScene",["ChooseCampainDeck"])
	back_button.connect("button_down",self,"nextScene",["Main"])
