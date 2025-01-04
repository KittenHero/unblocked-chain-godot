extends Node

func _process(_delta: float) -> void:
	var data := LiveDebug.data
	for section: String in data:
		var box := find_or_create(section)
		var message: String = data[section]
		var display: Label = box.get_child(1)
		display.text = message

func find_or_create(section: String) -> HBoxContainer:
	if has_node(section): return get_node(section)
	var box := HBoxContainer.new()
	box.name = section
	add_child(box)
	var label := Label.new()
	label.text = section
	box.add_child(label)
	label = Label.new()
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	box.add_child(label)
	return box
