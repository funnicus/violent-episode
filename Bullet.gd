extends Node2D

var direction: Vector2 = Vector2()
var speed: float = 500  
var ttl: float = 1  # Time when bullet dissappears
var velocity: Vector2 = Vector2.ZERO

func _ready():
	self.add_to_group("Bullets")
	await get_tree().create_timer(ttl).timeout
	queue_free()
	
func _physics_process(delta):
	position += velocity * delta
	

	
