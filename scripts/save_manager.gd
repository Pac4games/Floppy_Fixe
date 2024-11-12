extends Node

const SAVE_FILE_PATH:String = "user://floppy_fixe.save"

var high_score:int

func load_high_score() -> void:
	if (FileAccess.file_exists(SAVE_FILE_PATH)):
		var save_file:FileAccess = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
		high_score = int(save_file.get_as_text())
		save_file.close()
	else:
		high_score = 0

func check_high_score(new_score:int) -> void:
	if (new_score > high_score):
		high_score = new_score
		var save_file:FileAccess = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
		save_file.store_string(str(high_score))
		save_file.close()

func _ready() -> void:
	load_high_score()
