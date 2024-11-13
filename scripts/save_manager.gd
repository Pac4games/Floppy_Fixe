extends Node

const SAVE_FILE_PATH:String = "user://floppy_fixe.save"

var highscore:int

func load_highscore() -> void:
	if (FileAccess.file_exists(SAVE_FILE_PATH)):
		var save_file:FileAccess = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
		highscore = int(save_file.get_as_text())
		save_file.close()
	else:
		highscore = 0

func check_highscore(new_score:int) -> void:
	if (new_score > highscore):
		highscore = new_score
		var save_file:FileAccess = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
		save_file.store_string(str(highscore))
		save_file.close()

func _ready() -> void:
	load_highscore()
