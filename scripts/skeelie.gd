extends CharacterBody2D

@export var START_POS:Vector2 = Vector2(1064, 300)
@export var MOVE_RANGE:float = 170.0
@export var MOVE_SPEED:float = 1.5
@export var BULLET_SPEED:float = 500.0
@export var BULLET_OFFSET:float = 80.0
@export var BULLET_COOLDOWN:float = 1.5
@export var BULLET_ANGLE:float = 25.0
@export var BULLET_AMMO:int = 10
@export var SCORE_AREA_OFFSET = 20.0

@onready var animation_player:AnimationPlayer = $AnimationPlayer
@onready var shoot_sfx:AudioStreamPlayer2D = $ShootSFX
@onready var explosion:AnimatedSprite2D = $Explosion
@onready var explosion_sfx:AudioStreamPlayer2D = $ExplosionSFX
@onready var timer:Timer = $Timer
@onready var collider:CollisionShape2D = $CollisionShape2D
@onready var projectile_scene:PackedScene = load("res://scenes/projectile.tscn")
@onready var score_area_scene:PackedScene = load("res://scenes/projectile_score_area.tscn")
@onready var main:Node

var moving:bool
var is_dead:bool
var base_y:float
var time_passed:float = 0.0
var phase_num:int = 0
var random_move_dir:int = 1
var bullets:Array

func _ready() -> void:
	main = get_tree().get_root().get_node("Main")
	if (randi_range(0, 1)):
		random_move_dir = -1
	moving = false
	spawn()

# Boss movement
func _process(delta:float) -> void:
	if (moving):
		time_passed += delta * MOVE_SPEED
		position.y = base_y + (sin(time_passed) * MOVE_RANGE * random_move_dir)
	else:
		position = position.lerp(START_POS, delta * MOVE_SPEED * 4)

	if (position.distance_to(START_POS) < 1.0):
		position = START_POS

func spawn() -> void:
	animation_player.play("spawn")
	await (animation_player.animation_finished)
	base_y = position.y
	await (bullet_phase())
	if (!main.game_over):
		fucking_explode()

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
				bullet.add_child(score_area_scene.instantiate())
			1:
				bullet.dir = rotation + deg_to_rad(BULLET_ANGLE)
			2:
				bullet.dir = rotation + deg_to_rad(-BULLET_ANGLE)

		bullets.append(bullet)
		main.add_child(bullet)
		shoot_sfx.play()
		idx += 1

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
	moving = false

	return (1)

func fucking_explode() -> void:
	moving = false
	while (position != START_POS):
		await (get_tree().process_frame)

	animation_player.play("impact")
	await (animation_player.animation_finished)
	explosion.visible = true
	explosion.play("default")
	explosion_sfx.play()
	animation_player.play("begone")
	await (animation_player.animation_finished)
	main.boss_spawned = false
