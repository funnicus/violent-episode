extends Node2D
var EnemyScene = preload("res://scenes/enemy.tscn")
var EnemyScene2 = preload("res://scenes/enemy_2.tscn")
var weapon_node
var enemy_count = 0

func _ready():
	weapon_node = get_node("Weapon")
	# Connect weapons custom signal to the function to summon enemies
	weapon_node.connect("weapon_picked_up", Callable(self, "_on_weapon_picked_up"))

func _on_weapon_picked_up():
	if enemy_count == 0:
		# spawn first enemy
		await get_tree().create_timer(0.5).timeout
		spawn_enemy(Vector2(450, 600))

func spawn_enemy(position):
	var enemy = EnemyScene.instantiate()
	enemy.position = position
	enemy.add_to_group("enemies")
	enemy.connect("enemy_defeated", Callable(self, "_on_enemy_defeated"))
	add_child(enemy)
	print("Enemy spawned at position", position)
	
func spawn_enemy2(position):
	var enemy = EnemyScene2.instantiate()
	enemy.position = position
	enemy.add_to_group("enemies")
	enemy.connect("enemy_defeated", Callable(self, "_on_enemy_defeated"))
	add_child(enemy)
	print("Enemy spawned at position", position)	
	
func _on_enemy_defeated():
	enemy_count += 1
	print("Enemy defeated. Updating count to: ", enemy_count)
	# Spawn more enemies after the first is defeated
	if enemy_count == 1:
		await get_tree().create_timer(0.5).timeout
		spawn_enemy(Vector2(450, 600))
		spawn_enemy(Vector2(660, 600))
	elif enemy_count == 3:
		await get_tree().create_timer(0.5).timeout
		spawn_enemy(Vector2(450, 600))
		spawn_enemy2(Vector2(660, 600))
		spawn_enemy(Vector2(660, 500))
	elif enemy_count == 6:
		await get_tree().create_timer(0.5).timeout
		spawn_enemy2(Vector2(450, 600))
		spawn_enemy(Vector2(660, 600))
		spawn_enemy2(Vector2(660, 500))
		
		# Opens the door after killin all the enemies
	elif enemy_count == 9:
		await get_tree().create_timer(1.2).timeout
		var door_node = get_node("Door")
		door_node.open_door()
