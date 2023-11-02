extends CharacterBody2D

var camera: Camera2D
const MAX_SPEED = 110
var input = Vector2.ZERO
var bullet_scene : PackedScene = preload("res://Bullet.tscn")
@export var bullet_speed: float = 200
@export var ghost_node : PackedScene
@onready var ghost_timer = $GhostTimer
@onready var particles =$GPUParticles2D

var cooldown_duration: float = 0.5 #seconds between shots
var last_shot_time: float = -cooldown_duration

var rng = RandomNumberGenerator.new()

# Stepping sound effects
var StepSounds = [
	preload("res://sound/misc/step1.ogg"),
	preload("res://sound/misc/step2.ogg"),
	preload("res://sound/misc/step3.ogg")
]

var ShootingSounds = [
	preload("res://sound/shooting/shoot1.ogg"),
	preload("res://sound/shooting/shoot2.ogg"),
	preload("res://sound/shooting/shoot3.ogg"),
	preload("res://sound/shooting/shoot4.ogg"),
	preload("res://sound/shooting/shoot5.ogg")
]

func _ready():
	$Hitbox.connect("body_entered", Callable(self, "_on_body_entered"))
	camera = $Camera2D
	self.set_process_input(true)
	
func _physics_process(delta):
	handle_movement_2(delta)
	
	#look_at(get_global_mouse_position())

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
		
		# play step sound effect when walking
		if !$WalkingSound.is_playing():
			$WalkingSound.stream = StepSounds[rng.randi_range(0, StepSounds.size() - 1)]
			$WalkingSound.play()
	move_and_slide()

func _process(delta):
	camera.position.y = global_position.y - 350
	last_shot_time += delta
	
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if last_shot_time >= cooldown_duration:
			shoot(event.global_position)
			last_shot_time = 0
	
	if event.is_action_pressed("dash"):
		dash()

func shoot(target_position):
	var direction = target_position - global_position
	direction = direction.normalized()
	
	var bullet = bullet_scene.instantiate()
	bullet.name = "Bullet"
	bullet.velocity = direction * bullet_speed
	bullet.position = global_position
	
	bullet.rotation = direction.angle() + PI/2
	get_parent().add_child(bullet)
	$ShootingSound.stream = ShootingSounds[rng.randi_range(0, ShootingSounds.size() - 1)]
	$ShootingSound.play()
	
func die():
	print("Player is dead")
	position = Vector2(550, 440)


func _on_hitbox_body_entered(body):
	if body.name == "Enemy":
		die()

#func add_ghost():
	#var ghost = ghost_node.instantiate()
	#ghost.set_property(position, $Sprite2D.scale)

#func _on_ghost_timer_timeout():
	#add_ghost()

func dash():
	#ghost_timer.start()
	particles.emitting = true
	
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", position + velocity * 1.5, 0.30)
	
	await tween.finished
	#ghost_timer.stop()
	particles.emitting = false
