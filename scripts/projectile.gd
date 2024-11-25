extends CharacterBody2D

@onready var spawnPos:Vector2
@onready var speed:float
@onready var dir:float

func _ready() -> void:
	global_position = spawnPos
	global_scale = Vector2(1, 1)

func _physics_process(_delta:float) -> void:
	velocity = Vector2(-speed, 0).rotated(dir)
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body.name == "Fixe"):
		body.die()
