extends Control

onready var play_button = $MainMenu/VBOX/PlayButton
onready var hostjoin_button = $MainMenu/VBOX/HostJoinButton
onready var mydeck_button = $MainMenu/VBOX/MyDeckButton
onready var saveload_button = $MainMenu/VBOX/SaveLoadButton
onready var options_button = $MainMenu/VBOX/OptionsButton

func nextScene(sceneName):
	get_node("/root/global").delayNextScene(sceneName)

func _ready():
	play_button.connect("button_down",self,"nextScene",["Play"])
	hostjoin_button.connect("button_down",self,"nextScene",["HostJoin"])
	mydeck_button.connect("button_down",self,"nextScene",["MyDeck"])
	saveload_button.connect("button_down",self,"nextScene",["SaveLoad"])
	options_button.connect("button_down",self,"nextScene",["Options"])
