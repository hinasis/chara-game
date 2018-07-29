extends Node

var currentScene = null
var currentSceneName = ""
var previousSceneName = ""
var delayer

func _ready():
	currentScene = get_tree().get_root().get_child(get_tree().get_root().get_child_count()-1)
	delayer = Timer.new()
	delayer.wait_time = 0.01
	delayer.one_shot = true
	add_child(delayer)

func setScene(sceneName=""):
	var fl = File.new()
	if fl.file_exists("res://Scenes/"+sceneName+"Scene.tscn"):
		currentScene.queue_free()
		var s = ResourceLoader.load("res://Scenes/"+sceneName+"Scene.tscn")
		currentScene = s.instance()
		get_tree().get_root().add_child(currentScene)
		previousSceneName = currentSceneName
		currentSceneName = sceneName

func delayNextScene(sceneName=""):
	delayer.connect("timeout",self,"delayerTimeout",[sceneName])
	delayer.start()

func delayerTimeout(sceneName):
	setScene(sceneName)
	delayer.disconnect("timeout",self,"delayerTimeout")
