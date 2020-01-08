extends GraphNode

onready var parent = self.get_parent().get_parent()

var node_id = 0
var real_id = 0
var Type = "text"
var Name = ""
var Text = ""
var const_size = null
var line_count = 1

onready var nameList = $"HSplitContainer/VBoxContainer/All/Name text"

signal text_butt(offset)


func _ready():
	real_id = node_id
	const_size = rect_min_size
	line_count = $"HSplitContainer/VBoxContainer/All/Text text".get_line_count()
	$"HSplitContainer/Buttons/Text".connect("pressed", parent, "_create_and_connect", [self, "text"])
	$"HSplitContainer/Buttons/Divert".connect("pressed", parent, "_create_and_connect", [self, "divert"])
	$"HSplitContainer/Buttons/Question".connect("pressed", parent, "_create_and_connect", [self, "question"])
	$"HSplitContainer/Buttons/Action".connect("pressed", parent, "_create_and_connect", [self, "action"])
	$"HSplitContainer/Buttons/Random".connect("pressed", parent, "_create_and_connect", [self, "random"])


func _process(delta):
	rect_size = const_size


func loading(node):

	if node.has("name"):
		$"All/Name text".text = node["name"]
		Name = node["name"]

	if node.has("content"):
		$"All/Text text".text = node["content"]
		Text = node["content"]


func _on_Text_node_close_request():
	queue_free()


func _on_Text_node_resize_request(new_minsize):
	rect_size = new_minsize
	const_size = new_minsize


func _on_ID_text_text_changed():
	node_id = $"HSplitContainer/VBoxContainer/All/ID text".text


func _on_Text_node_resized():
	$"HSplitContainer/VBoxContainer/All".rect_min_size.y = self.get_rect().size.y - 70


func _on_Name_text_text_changed():
	Name = $"HSplitContainer/VBoxContainer/All/Name text".text


func _on_Name_text_item_selected(ID):
	Name = nameList.get_item_text(ID)


func _on_Text_text_text_changed():
	Text = $"HSplitContainer/VBoxContainer/All/Text text".text
	_resize()


func _resize():
	while line_count != $"HSplitContainer/VBoxContainer/All/Text text".get_line_count():
		if line_count < $"HSplitContainer/VBoxContainer/All/Text text".get_line_count():
			self.rect_min_size.y = self.rect_min_size.y + 18
			line_count = line_count + 1
		if line_count > $"HSplitContainer/VBoxContainer/All/Text text".get_line_count():
			self.rect_min_size.y = self.rect_min_size.y - 18
			line_count = line_count - 1


func _on_First_checkbox_pressed():
	if $"HSplitContainer/VBoxContainer/Firstrepeat/First/First checkbox".pressed == true:
		$"HSplitContainer/VBoxContainer/Firstrepeat/Repeat/Repeat checkbox".pressed = false
		node_id = "first"
	else:
		node_id = real_id


func _on_Repeat_checkBox_pressed():
	if $"HSplitContainer/VBoxContainer/Firstrepeat/Repeat/Repeat checkbox".pressed == true:
		$"HSplitContainer/VBoxContainer/Firstrepeat/First/First checkbox".pressed = false
		node_id = "repeat"
	else:
		node_id = real_id


func _add_name(name):
	nameList.add_item(name)


func _edit_name(id, to):
	nameList.set_item_text(id, to)


func _remove_name(id):
		nameList.remove_item(id)