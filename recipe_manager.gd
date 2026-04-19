extends Node

var combinations: Dictionary = {}
var base_emojis: Array = []
var discovered_emojis: Array = []

signal sequence_discovered(emoji: String)

func _ready():
	load_data()
	for emoji in base_emojis:
		if not discovered_emojis.has(emoji):
			discovered_emojis.append(emoji)

func load_data():
	var file_path = "res://assets/game_data.json"
	if not FileAccess.file_exists(file_path):
		printerr("Error: game_data.json not found at ", file_path)
		return

	var file = FileAccess.open(file_path, FileAccess.READ)
	var content = file.get_as_text()
	var json = JSON.new()
	var error = json.parse(content)
	
	if error == OK:
		var data = json.get_data()
		base_emojis = data.get("base_emojis", ["💧", "🔥", "🌍", "💨"])
		var recipes = data.get("recipes", {})
		
		# Convert flat comma-separated recipes to nested dictionary for faster lookups
		for key in recipes.keys():
			var parts = key.split(",")
			if parts.size() == 2:
				var e1 = parts[0]
				var e2 = parts[1]
				var result = recipes[key]
				
				_add_combination(e1, e2, result)
				_add_combination(e2, e1, result) # Ensure commutativity
		print("Successfully loaded ", recipes.size(), " recipes.")
	else:
		printerr("JSON Parse Error: ", json.get_error_message(), " at line ", json.get_error_line())

func _add_combination(e1: String, e2: String, result: String):
	if not combinations.has(e1):
		combinations[e1] = {}
	combinations[e1][e2] = result

func can_combine(emoji1: String, emoji2: String) -> bool:
	return combinations.has(emoji1) and combinations[emoji1].has(emoji2)

func combine(emoji1: String, emoji2: String) -> String:
	if can_combine(emoji1, emoji2):
		var result = combinations[emoji1][emoji2]
		if not discovered_emojis.has(result):
			discovered_emojis.append(result)
			sequence_discovered.emit(result)
		return result
	return ""
