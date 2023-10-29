extends CharacterBody2D

var camera: Camera2D
const MAX_SPEED = 110
var input = Vector2.ZERO
var bullet_scene : PackedScene = preload("res://Bullet.tscn")
@export var bullet_speed: float = 200

var cooldown_duration: float = 0.5 #seconds between shots
var last_shot_time: float = -cooldown_duration

func _ready():
	$Hitbox.connect("body_entered", Callable(self, "_on_body_entered"))
	camera = $Camera2D
	self.set_process_input(true)
	
func _physics_process(delta):
	handle_movement_2(delta)

func get_input():
	input.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	input.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	return input.normalized()

func handle_movement_2(delta):
	input = get_input()
	if input == Vector2.ZERO:
		velocity = Vector2.ZERO
	else:
		velocity = (input * MAX_SPEED)
		velocity = velocity.limit_length(MAX_SPEED)
	move_and_slide()

func _process(delta):
	camera.position.y = global_position.y - 350
	last_shot_time += delta
	
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if last_shot_time >= cooldown_duration:
			shoot(event.global_position)
			last_shot_time = 0
		
func shoot(target_position):
	var direction = target_position - global_position
	direction = direction.normalized()
	
	var bullet = bullet_scene.instantiate()
	bullet.name = "Bullet"
	bullet.velocity = direction * bullet_speed
	bullet.position = global_position
	
	bullet.rotation = direction.angle() + PI/2
	get_parent().add_child(bullet)
	
func die():
	print("Player is dead")
	position = Vector2(550, 440)


func _on_hitbox_body_entered(body):
	if body.name == "Enemy":
		die()