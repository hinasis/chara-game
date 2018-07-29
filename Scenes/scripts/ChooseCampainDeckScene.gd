extends Control

onready var deck1_button = $ChooseArea/VBOX/HBOX/Deck1Button
onready var deck2_button = $ChooseArea/VBOX/HBOX/Deck2Button
onready var back_button = $ChooseArea/VBOX/BackButton

func nextScene(sceneName):
	get_node("/root/global").delayNextScene(sceneName)

func _ready():
	deck1_button.connect("button_down",self,"nextScene",["Game"])
	deck2_button.connect("button_down",self,"nextScene",["Game"])
	back_button.connect("button_down",self,"nextScene",["Play"])
