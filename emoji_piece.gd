extends PanelContainer

var emoji_string: String = "💧"
var is_inventory_item: bool = false

@onready var label: Label = $Label

func _ready():
	label.text = emoji_string
	_setup_style()

func set_emoji(emoji: String, inventory: bool = false):
	emoji_string = emoji
	is_inventory_item = inventory
	if label:
		label.text = emoji_string

func _setup_style():
	var style = StyleBoxFlat.new()
	style.bg_color = Color(1.0, 1.0, 1.0, 0.9)
	style.corner_radius_top_left = 20
	style.corner_radius_top_right = 20
	style.corner_radius_bottom_left = 20
	style.corner_radius_bottom_right = 20
	style.shadow_color = Color(0, 0, 0, 0.1)
	style.shadow_size = 10
	add_theme_stylebox_override("panel", style)
	
	# Give the control a predictable size
	custom_minimum_size = Vector2(100, 100)
	size = Vector2(100, 100)
	pivot_offset = size / 2.0

func _get_drag_data(at_position: Vector2):
	# Create a preview
	var preview = preload("res://emoji_piece.tscn").instantiate()
	preview.set_emoji(emoji_string, false)
	preview.modulate.a = 0.8
	var c = Control.new()
	c.add_child(preview)
	preview.position = -preview.size / 2
	set_drag_preview(c)
	
	return {"type": "emoji", "emoji": emoji_string, "source_node": self, "is_inventory": is_inventory_item}

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	if typeof(data) == TYPE_DICTIONARY and data.has("type") and data["type"] == "emoji":
		var dragged_emoji = data["emoji"]
		var source = data["source_node"]
		# In this game loop, if dragged item matches this item, it can drop
		if source != self and RecipeManager.can_combine(emoji_string, dragged_emoji):
			return true
	return false

func _drop_data(at_position: Vector2, data: Variant):
	var dragged_emoji = data["emoji"]
	var result = RecipeManager.combine(emoji_string, dragged_emoji)
	if result != "":
		# Spawn new emoji here
		var new_piece = preload("res://emoji_piece.tscn").instantiate()
		new_piece.set_emoji(result, false)
		new_piece.position = position
		get_parent().add_child(new_piece)
		
		# Destroy sender (if not coming from inventory) and receiver
		if not data["is_inventory"] and is_instance_valid(data["source_node"]):
			data["source_node"].queue_free()
		queue_free()
