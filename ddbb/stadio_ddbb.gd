extends Node

var sa = []
func _init():
	var STADIO = {"names":"","collection":""}
	#---------------------------#
	STADIO.names= ["earth"]
	STADIO.collection = "test"
	sa.append(STADIO.duplicate())
	#---------------------------#
	STADIO.names= ["fire"]
	STADIO.collection = "test"
	sa.append(STADIO.duplicate())
	#---------------------------#
	STADIO.names= ["water"]
	STADIO.collection = "test"
	sa.append(STADIO.duplicate())
	#---------------------------#
	STADIO.names= ["air"]
	STADIO.collection = "test"
	sa.append(STADIO.duplicate())
	#---------------------------#
	STADIO.names= ["light"]
	STADIO.collection = "test"
	sa.append(STADIO.duplicate())
	#---------------------------#
	STADIO.names= ["dark"]
	STADIO.collection = "test"
	sa.append(STADIO.duplicate())
