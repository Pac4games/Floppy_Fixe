extends CharacterBody2D

@export var START_POS:Vector2 = Vector2(1229, 324)

@onready var animation_player:AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	position = START_POS
	self.hide()

func spawn() -> void:
	print("SPAWNING FUCK")
	self.show()
	$AnimationPlayer.play("spawn")
