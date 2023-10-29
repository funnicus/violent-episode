extends Node2D


func _ready():
	print("door ready")
	# Initialize the door to be closed
	$ClosedDoorSprite.visible = true
	$OpenDoorSprite.visible = false
	
	

func open_door():
	$ClosedDoorSprite.visible = false
	$OpenDoorSprite.visible = true

	$StaticBody2D/CollisionShape2D.disabled = true
	$StaticBody2D/CollisionShape2D.shape = null
	

