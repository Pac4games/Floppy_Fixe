extends Area2D

signal scored

func _on_body_entered(_body: Node2D) -> void:
	scored.emit()
