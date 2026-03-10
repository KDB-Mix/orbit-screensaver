extends Node

const CONFIG_PATH = "user://config.json"
const DEFAULTS = {
	"ballCount": 120,
	"fps": 30,
	"transparentBG": false,
	"bgColor": "000000ff",
	}

var settings={}
func load_config():
	settings = DEFAULTS.duplicate()
	if not FileAccess.file_exists(CONFIG_PATH):
		save_config()
		return
	var file = FileAccess.open(CONFIG_PATH, FileAccess.READ)
	var parsed = JSON.parse_string(file.get_as_text())
	file.close()
	if parsed == null:
		save_config()
		return
	for key in DEFAULTS.keys():
		settings[key] = parsed.get(key, DEFAULTS[key])
	save_config()

func save_config():
	var file = FileAccess.open(CONFIG_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(settings, "\t"))
	file.close()
