extends Node2D

var enemies_in_room: Array = []
var total_enemies: int = 0

func _ready():
	print("door ready")
	# Initialize the door to be closed
	$ClosedDoorSprite.visible = true
	$OpenDoorSprite.visible = false

	

func initialize_door():
	enemies_in_room = get_tree().get_nodes_in_group("enemies")
	total_enemies = enemies_in_room.size()
	for enemy in enemies_in_room:
		enemy.connect("enemy_defeated", Callable(self, "_on_enemy_defeated"))
	
		
		
func _on_enemy_defeated():
	total_enemies -= 1
	print(total_enemies)
	if total_enemies == 0:
		# Opens the door
		$ClosedDoorSprite.visible = false
		$OpenDoorSprite.visible = true
		
		$StaticBody2D/CollisionShape2D.disabled = true
		$StaticBody2D/CollisionShape2D.shape = null
		print("door open")
