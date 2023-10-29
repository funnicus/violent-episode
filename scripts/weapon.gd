extends Node2D
signal weapon_picked_up

func _ready():
	print("Weapon is ready!")



func _on_area_2d_body_entered(body):
	if body.name == "Player":
		emit_signal("weapon_picked_up")
		self.queue_free()
