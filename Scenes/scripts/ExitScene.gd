extends Control

onready var yes_button = $ExitMenu/VBOX/HBOX/YesButton
onready var no_button = $ExitMenu/VBOX/HBOX/NoButton

func exitGame():
	get_tree().quit()
func goBackTo():
	if get_node("/root/global").previousSceneName == "Lobby":
		get_node("/root/global").delayNextScene("Lobby")
	elif get_node("/root/global").previousSceneName == "Options":
		get_node("/root/global").delayNextScene("Options")

func _ready():
	yes_button.connect("button_down",self,"exitGame")
	no_button.connect("button_down",self,"goBackTo")

