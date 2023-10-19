extends Node2D
var EnemyScene = preload("res://enemy.tscn")
var weapon_node

func _ready():
	weapon_node = get_node("Weapon")
	# Connect weapons custom signal to the function to summon enemies
	weapon_node.connect("weapon_picked_up", Callable(self, "_on_weapon_picked_up"))

func _on_weapon_picked_up():
	# Create two instances of the enemy
	var enemy1 = EnemyScene.instantiate()
	var enemy2 = EnemyScene.instantiate()
	
	
	# Add the enemies to the 'enemies' group
	enemy1.add_to_group("enemies")
	enemy2.add_to_group("enemies")

	# Set enemies positions
	enemy1.position = Vector2(450, 600) # Example position
	enemy2.position = Vector2(660, 600) # Example position

	# Add the enemies to the main scene
	add_child(enemy1)
	add_child(enemy2)
	
	var door_node = get_node("Door")
	door_node.initialize_door()


