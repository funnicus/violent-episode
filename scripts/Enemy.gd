extends CharacterBody2D

signal enemy_defeated

var speed = 30
var player_chase = false
var player = null



func _ready():
	print("Enemy is ready!")
	
func _physics_process(delta):
	if player_chase:
		var direction = (player.position - position).normalized()
		position += direction * speed * delta
		move_and_slide()
	

func _on_area_2d_body_entered(body):
	print("Player detectecd")
	player = body
	player_chase = true


func _on_area_2d_body_exited(body):
	player = null
	player_chase = false


func _on_death_area_entered(area):
	if "Bullet_Area" in area.name:
		emit_signal("enemy_defeated")
		area.get_parent().queue_free()
		queue_free()
		
