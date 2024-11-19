extends CharacterBody2D

@export var START_POS:Vector2 = Vector2(1229, 300)

@export var MOVE_RANGE:float = 170.0
@export var MOVE_SPEED:float = 1.5
@export var BULLET_SPEED:float = 500.0
@export var BULLET_OFFSET:float = 80.0
@export var BULLET_COOLDOWN:float = 1.5
@export var BULLET_ANGLE:float = 25.0
@export var BULLET_AMMO:int = 5

@onready var animation_player:AnimationPlayer = $AnimationPlayer
@onready var shoot_sfx:AudioStreamPlayer2D = $ShootSFX
@onready var timer:Timer = $Timer
@onready var collider:CollisionShape2D = $CollisionShape2D
@onready var projectile_scene:PackedScene = load("res://scenes/projectile.tscn")
@onready var eel_scene:PackedScene = load("res://scenes/eels.tscn")
@onready var main:Node

var moving:bool
var base_y:float
var time_passed:float = 0.0
var phase_num:int = 0
var random_move_dir:int = 1
var bullets:Array

func _ready() -> void:
	main = get_tree().root
	position = START_POS
	if (randi_range(0, 1)):
		random_move_dir = -1
	moving = false
	collider.disabled = true
	spawn()

# Boss movement
func _process(delta:float) -> void:
	if (moving):
		time_passed += delta * MOVE_SPEED
		position.y = base_y + (sin(time_passed) * MOVE_RANGE * random_move_dir)

func spawn() -> void:
	animation_player.play("spawn")
	await (animation_player.animation_finished)
	base_y = position.y
	await (bullet_phase())
	die()

func clear_bullets() -> void:
	for bullet in bullets:
		bullet.queue_free()
	bullets.clear()

func spawn_bullet_spread(bullet_spread:Array) -> void:
	var idx:int = 0
	for bullet in bullet_spread:
		bullet = projectile_scene.instantiate()
		bullet.spawnPos = global_position
		bullet.spawnPos.x -= BULLET_OFFSET
		bullet.speed = BULLET_SPEED

		match idx:
			0:
				bullet.dir = rotation
			1:
				bullet.dir = rotation + deg_to_rad(BULLET_ANGLE)
			2:
				bullet.dir = rotation + deg_to_rad(-BULLET_ANGLE)

		bullets.append(bullet)
		main.add_child(bullet)
		shoot_sfx.play()
		idx += 1

func spawn_bullet_score_trigger() -> void:
	pass

func bullet_phase() -> int:
	moving = true

	for i in BULLET_AMMO:
		var bullet_spread:Array
		bullet_spread.resize(3)
		spawn_bullet_spread(bullet_spread)
		timer.start(BULLET_COOLDOWN)
		await (timer.timeout)
		bullet_spread.clear()
	
	timer.start(BULLET_COOLDOWN)
	await (timer.timeout)
	clear_bullets()

	return (1)

func die() -> void:
	collider.disabled = false
