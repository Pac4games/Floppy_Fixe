extends CharacterBody2D

@onready var animated_sprite:AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player:AnimationPlayer = $AnimationPlayer
@onready var flop_sfx:AudioStreamPlayer2D = $SFXs/Flop_SFX
@onready var death_sfx:AudioStreamPlayer2D = $SFXs/Death_SFX

@export var GRAVITY:int = 1000
@export var MAX_VELOCITY:int = 600
@export var FLOP_SPEED:int = -500
@export var START_POS:Vector2 = Vector2(576, 324)

var flying:bool
var falling:bool

func die() -> void:
	get_parent().player_hit()

func reset() -> void:
	falling = false
	flying = false
	position = START_POS    # Already created by CharacterBody2D
	set_rotation(0)
	animation_player.play("idle")

func flop() -> void:
	flop_sfx.play()
	velocity.y = FLOP_SPEED

func _ready() -> void:
	reset()

func _physics_process(delta:float) -> void:
	if (flying || falling):
		velocity.y += GRAVITY * delta
		# Limiting velocity so it won't get higher than MAX_VELOCITY
		if (velocity.y > MAX_VELOCITY):
			velocity.y = MAX_VELOCITY

		if (flying):
			set_rotation(deg_to_rad(velocity.y * 0.05))
			animated_sprite.play()
		elif (falling):
			set_rotation(PI / 2)
			animated_sprite.stop()

		move_and_collide(velocity * delta)
	else:
		animated_sprite.stop()
