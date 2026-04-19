extends Node

var combinations: Dictionary = {
	"💧": {"🔥": "💨", "🌍": "🌱", "💧": "🌊"},
	"🔥": {"💧": "💨", "🌍": "🌋", "💨": "⚡"},
	"🌍": {"💧": "🌱", "🔥": "🌋", "💨": "🌪️"},
	"💨": {"🔥": "⚡", "🌍": "🌪️", "💧": "🌧️"}
}

var base_emojis: Array = ["💧", "🔥", "🌍", "💨"]
var discovered_emojis: Array = []

signal sequence_discovered(emoji: String)

func _ready():
	_ensure_commutative_combinations()
	for emoji in base_emojis:
		discovered_emojis.append(emoji)

func _ensure_commutative_combinations():
	var new_combinations = combinations.duplicate(true)
	for a in combinations.keys():
		for b in combinations[a].keys():
			var result = combinations[a][b]
			if not new_combinations.has(b):
				new_combinations[b] = {}
			new_combinations[b][a] = result
	combinations = new_combinations

func can_combine(emoji1: String, emoji2: String) -> bool:
	if combinations.has(emoji1) and combinations[emoji1].has(emoji2):
		return true
	return false

func combine(emoji1: String, emoji2: String) -> String:
	if can_combine(emoji1, emoji2):
		var result = combinations[emoji1][emoji2]
		if not discovered_emojis.has(result):
			discovered_emojis.append(result)
			sequence_discovered.emit(result)
		return result
	return ""
