tool
extends GraphNode

onready var parent = self.get_parent().get_parent().get_parent().get_parent()

var node_id = 0
var real_id = 0
var Type = "text"
var Name = ""
var Text = ""
var const_size = null
var line_count = 1

onready var nameList = $"HSplitContainer/VBoxContainer/All/Name container/Name text"

signal text_butt(offset)


func _ready():
	real_id = node_id
	rect_min_size.y = 200
	rect_size.y = 200
	line_count = $"HSplitContainer/VBoxContainer/All/Text text".get_line_count()
	$"HSplitContainer/Buttons/Text".connect("pressed", parent, "_create_and_connect", [self, "text"])
	$"HSplitContainer/Buttons/Divert".connect("pressed", parent, "_create_and_connect", [self, "divert"])
	$"HSplitContainer/Buttons/Question".connect("pressed", parent, "_create_and_connect", [self, "question"])
	$"HSplitContainer/Buttons/Action".connect("pressed", parent, "_create_and_connect", [self, "action"])
	$"HSplitContainer/Buttons/Random".connect("pressed", parent, "_create_and_connect", [self, "random"])


func _process(delta):
	if rect_size.y > 200:
		emit_signal("resized")


func loading(node, id):

	if str(node["real_id"]) != id and id != "first" and id != "repeat":
		$"HSplitContainer/VBoxContainer/All/ID container/ID text".text = id

	if node.has("name"):
		Name = node["name"]
		var namelist = $"HSplitContainer/VBoxContainer/All/Name container/Name text"
		for i in range(1, namelist.get_item_count()):
			if namelist.get_item_text(i) == Name:
				namelist.select(i)
				break

	if node.has("content"):
		Text = node["content"]
		$"HSplitContainer/VBoxContainer/All/Text text".text = node["content"]

func _set_node_id(id):
	node_id = id

func _on_Text_node_close_request():
	parent.changed = true
	queue_free()


func _on_Text_node_resize_request(new_minsize):
	rect_size = new_minsize
	const_size = new_minsize


func _on_ID_text_text_changed():
	parent.changed = true
	node_id = $"HSplitContainer/VBoxContainer/All/ID container/ID text".text


func _on_Text_node_resized():
#	$"HSplitContainer/VBoxContainer/All".rect_min_size.y = self.get_rect().size.y - 70
	rect_size.y = rect_min_size.y
	rect_size.x = 333

func _on_Name_text_text_changed():
	parent.changed = true
	Name = $"HSplitContainer/VBoxContainer/All/Name container/Name text".text


func _on_Name_text_item_selected(ID):
	parent.changed = true
	Name = nameList.get_item_text(ID)


func _on_Text_text_text_changed():
	parent.changed = true
	Text = $"HSplitContainer/VBoxContainer/All/Text text".text
#	_resize()


func _resize():
	while line_count != $"HSplitContainer/VBoxContainer/All/Text text".get_line_count():
		if line_count < $"HSplitContainer/VBoxContainer/All/Text text".get_line_count():
			self.rect_min_size.y = self.rect_min_size.y + 18
			line_count = line_count + 1
		if line_count > $"HSplitContainer/VBoxContainer/All/Text text".get_line_count():
			self.rect_min_size.y = self.rect_min_size.y - 18
			line_count = line_count - 1

func _first_Flagged():
	parent.changed = true
	if typeof(node_id) == TYPE_STRING:
		if node_id == "first":
			node_id = real_id
			$"First flag".visible = false
		else:
			$"Repeat flag".visible = false
			node_id = "first"
			$"First flag".visible = true
	else:
		node_id = "first"
		$"First flag".visible = true

func _repeat_Flagged():
	parent.changed = true
	if typeof(node_id) == TYPE_STRING:
		if node_id == "repeat":
			node_id = real_id
			$"Repeat flag".visible = false
		else:
			$"First flag".visible = false
			node_id = "repeat"
			$"Repeat flag".visible = true
	else:
		node_id = "repeat"
		$"Repeat flag".visible = true

func _add_name(name):
	nameList.add_item(name)


func _edit_name(id, to):
	nameList.set_item_text(id, to)


func _remove_name(id):
		nameList.remove_item(id)
