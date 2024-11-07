extends CharacterBody2D

@onready var animated_sprite:AnimatedSprite2D = $AnimatedSprite2D

@export var GRAVITY:int = 1000
@export var MAX_VELOCITY:int = 600
@export var FLAP_SPEED:int = -500
@export var START_POS:Vector2 = Vector2(959, 541)

var flying:bool
var falling:bool

func reset() -> void:
	falling = false
	flying = false
	position = START_POS    # Already created by CharacterBody2D
	set_rotation(0)

func flap() -> void:
	velocity.y = FLAP_SPEED

func _ready() -> void:
	reset()

func _physics_process(delta:float) -> void:
	if (flying or falling):
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
