extends Control

onready var newgame_button = $LobbyMenuContainer/VBOX/NewGameButton
onready var load_button = $LobbyMenuContainer/VBOX/LoadButton
onready var exit_button = $LobbyMenuContainer/VBOX/ExitButton

func changeScene(to):
	var sceneName = ""
	if to == "new":
		sceneName = "CreateUser"
	if to == "load":
		sceneName = "Load"
	if to == "exit":
		sceneName = "Exit"
	get_node("/root/global").delayNextScene(sceneName)

func _ready():
	newgame_button.connect("button_down",self,"changeScene",["new"])
	load_button.connect("button_down",self,"changeScene",["load"])
	exit_button.connect("button_down",self,"changeScene",["exit"])
	