extends Node

func _ready() -> void:
	$AnimationPlayer.play("cool_af")

func _process(_delta:float) -> void:
	if (Input.is_action_just_pressed("Flop")):
		get_tree().change_scene_to_file("res://scenes/main.tscn")
