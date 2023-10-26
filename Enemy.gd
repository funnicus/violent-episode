extends CharacterBody2D

signal enemy_defeated

var speed = 30
var player_chase = false
var player = null



func _ready():
	print("Enemy is ready!")
	
func _physics_process(delta):
	if player_chase:
		position += (player.position - position)/speed


func _on_area_2d_body_entered(body):
	print("Player detectecd")
	player = body
	player_chase = true


func _on_area_2d_body_exited(body):
	player = null
	player_chase = false


func _on_death_body_entered(body):
	if body.name == "Player":
		print("Emitting enemy_defeated signal...")
		emit_signal("enemy_defeated")
		self.queue_free()
