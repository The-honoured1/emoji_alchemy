extends Control

@onready var inventory_box = $VBoxContainer/InventoryPanel/ScrollContainer/MarginContainer/InventoryBox

func _ready():
	_populate_inventory()
	RecipeManager.sequence_discovered.connect(_on_sequence_discovered)

func _populate_inventory():
	for child in inventory_box.get_children():
		child.queue_free()
		
	for emoji in RecipeManager.discovered_emojis:
		_add_to_inventory(emoji)

func _add_to_inventory(emoji: String):
	var piece = preload("res://emoji_piece.tscn").instantiate()
	inventory_box.add_child(piece)
	# Defers the label update until the piece is in the tree, though set_emoji is safe
	piece.set_emoji(emoji, true)

func _on_sequence_discovered(emoji: String):
	_add_to_inventory(emoji)
