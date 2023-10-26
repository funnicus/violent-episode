extends Node2D
var EnemyScene = preload("res://enemy.tscn")
var weapon_node
var enemy_count = 0

func _ready():
	weapon_node = get_node("Weapon")
	# Connect weapons custom signal to the function to summon enemies
	weapon_node.connect("weapon_picked_up", Callable(self, "_on_weapon_picked_up"))

func _on_weapon_picked_up():
	if enemy_count == 0:
		# spawn first enemy
		spawn_enemy(Vector2(450, 600))

func spawn_enemy(position):
	var enemy = EnemyScene.instantiate()
	enemy.position = position
	enemy.add_to_group("enemies")
	enemy.connect("enemy_defeated", Callable(self, "_on_enemy_defeated"))
	add_child(enemy)
	print("Enemy spawned at position", position)
	
func _on_enemy_defeated():
	enemy_count += 1
	print("Enemy defeated. Updating count to: ", enemy_count)
	if enemy_count == 1:
		# Spawn two enemies after the first is defeated
		spawn_enemy(Vector2(450, 600))
		spawn_enemy(Vector2(660, 600))
	elif enemy_count == 3:
		await get_tree().create_timer(0.1).timeout
		var door_node = get_node("Door")
		door_node.initialize_door()
