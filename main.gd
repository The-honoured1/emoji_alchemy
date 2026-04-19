extends Control

@onready var inventory_box = $VBoxContainer/InventoryPanel/ScrollContainer/MarginContainer/InventoryBox
@onready var board_area = $VBoxContainer/BoardArea
@onready var keyboard_alchemy = %KeyboardAlchemy

# Simple mapping for common names to emojis
var emoji_names: Dictionary = {
	"fire": "🔥", "water": "💧", "earth": "🌍", "wind": "💨",
	"lava": "🌋", "steam": "💨", "seed": "🌱", "tree": "🌳",
	"wave": "🌊", "sun": "☀️", "mountain": "⛰️", "storm": "⛈️",
	"rainbow": "🌈", "diamond": "💎", "gold": "💰", "life": "🌱"
}

func _ready():
	_populate_inventory()
	RecipeManager.sequence_discovered.connect(_on_sequence_discovered)
	keyboard_alchemy.text_submitted.connect(_on_keyboard_alchemy_submitted)

func _populate_inventory():
	for child in inventory_box.get_children():
		child.queue_free()
		
	for emoji in RecipeManager.discovered_emojis:
		_add_to_inventory(emoji)

func _add_to_inventory(emoji: String):
	var piece = preload("res://emoji_piece.tscn").instantiate()
	inventory_box.add_child(piece)
	piece.set_emoji(emoji, true)

func _on_sequence_discovered(emoji: String):
	_add_to_inventory(emoji)

func _on_keyboard_alchemy_submitted(text: String):
	keyboard_alchemy.clear()
	var clean_text = text.strip_edges().to_lower()
	if clean_text.is_empty():
		return

	var emojis_to_spawn: Array[String] = []
	
	# 1. Try to find known emoji names
	if emoji_names.has(clean_text):
		emojis_to_spawn.append(emoji_names[clean_text])
	else:
		# 2. Try to extract direct emojis from string
		# We'll treat every character as a potential emoji if it's not alphanumeric
		# but better yet, we'll just check if the string itself IS an emoji
		# or contains emojis. For simplicity in this demo, we'll split by chars
		# and check discovered_emojis or pool.
		
		# If user typed multiple emojis like 🔥💧
		var chars = clean_text.split("")
		for c in chars:
			# Very basic check: is it non-alphanumeric? (Unicode emojis are usually in high ranges)
			if c.unicode_at(0) > 127: 
				emojis_to_spawn.append(c)

	if emojis_to_spawn.is_empty():
		return

	# If they typed two emojis, try to combine them immediately
	if emojis_to_spawn.size() >= 2:
		var e1 = emojis_to_spawn[0]
		var e2 = emojis_to_spawn[1]
		var result = RecipeManager.combine(e1, e2)
		if result != "":
			_spawn_on_board(result)
		else:
			# Couldn't combine, just spawn them
			for e in emojis_to_spawn:
				_spawn_on_board(e)
	else:
		# Only one emoji, just spawn it
		_spawn_on_board(emojis_to_spawn[0])

func _spawn_on_board(emoji: String):
	var new_piece = preload("res://emoji_piece.tscn").instantiate()
	new_piece.set_emoji(emoji, false)
	board_area.add_child(new_piece)
	# Random position in the center area
	var random_offset = Vector2(randf_range(-100, 100), randf_range(-100, 100))
	new_piece.position = (board_area.size / 2.0) + random_offset - (new_piece.size / 2.0)
