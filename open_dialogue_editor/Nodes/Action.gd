tool
extends GraphNode

var node_id = 0
var real_id = 0
var Type = "action"
var Operation = "variable"
var Name = ""
var Text = ""
var slots_count = 4
var rec_min = 300
var all_miny = 105
var Dict = ""
var Value = []
var textbar = null
var textbar2 = null
var const_size = null

onready var nameList = $"All/Name container/Name text"
onready var parent = self.get_parent().get_parent().get_parent().get_parent()

func _ready():
	real_id = node_id
	rect_min_size.y = rec_min
	rect_size.y = rec_min
	_on_Add_pressed()
	const_size = rect_min_size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if rect_size.y > rec_min:
		emit_signal("resized")
#	$TextEdit.rect_size[1] = self.rect_size[1]-50


func loading(node, id):
	
	if str(node["real_id"]) != id:
		$"All/ID container/ID text".text = id
	
	if node.has("name"):
		$"All/Name text".text = node["name"]
		Name = node["name"]

	if node.has("content"):
		$"All/Text text".text = node["content"]
		Text = node["content"]

	if node.has("dictionary"):
		$"All/Dictionary container/Dictionary text".text = node["dictionary"]
		Dict = node["dictionary"]

	textbar.text = node["value"][0][0]
	textbar2.text = node["value"][0][1]
	Value[0] = [node["value"][0][0] , node["value"][0][1]]

	for i in range(1, node["value"].size()):
		_on_Add_pressed()
		textbar.text = node["value"][i][0]
		textbar2.text = node["value"][i][1]
		Value[i] = [node["value"][i][0] , node["value"][i][1]]


func _on_Action_node_close_request():
	parent.changed = true
	queue_free()


func _on_Action_node_resize_request(new_minsize):
	rect_size = new_minsize
	const_size = new_minsize

func _on_Action_node_resized():
	rect_size.y = rec_min
	rect_size.x = 333

func _on_Add_pressed():
	parent.changed = true
	all_miny += 60
	self.rect_min_size[1] += 60
	Value.append(["",""])

	var container = VBoxContainer.new()
	textbar = TextEdit.new()
	textbar2 = TextEdit.new()

	textbar.connect("text_changed", self, "_variable_Change", [textbar, slots_count-4])
	textbar2.connect("text_changed", self, "_value_Change", [textbar2, slots_count-4])

	container.rect_min_size[1] = 60
	container.set_v_size_flags(SIZE_EXPAND_FILL)
	textbar.set_v_size_flags(SIZE_EXPAND_FILL)
	textbar2.set_v_size_flags(SIZE_EXPAND_FILL)

	slots_count += 1

	container.add_child(HSeparator.new())
	container.add_child(textbar)
	container.add_child(textbar2)
	self.add_child(container)


func _on_Remove_pressed():
	parent.changed = true
	if slots_count > 5:
		all_miny -= 60
		self.rect_min_size[1] -= 60
		self.get_child(get_child_count()-1).queue_free()
		slots_count -= 1

func _on_ID_text_text_changed():
	parent.changed = true
	node_id = $"All/ID text".text

func _variable_Change(node, slot):
	parent.changed = true
	Value[slot][0] = node.text

func _value_Change(node, slot):
	parent.changed = true
	Value[slot][1] = node.text

func _on_Name_text_text_changed():
	parent.changed = true
	Name = $"All/Name text".text

func _on_Text_text_text_changed():
	parent.changed = true
	Text = $"All/Text text".text
	
func _on_Dictionary_text_text_changed():
	parent.changed = true
	Dict = $"All/Dictionary container/Dictionary text".text

func _first_Flagged():
	if typeof(node_id) == TYPE_STRING:
		if node_id == "first":
			node_id = real_id
			$"First flag".visible = false
		else:
			$"Repeat flag".visible = false
			node_id = "first"
			$"First flag".visible = true
	else:
		if typeof(node_id) == TYPE_INT:
			node_id = "first"
			$"First flag".visible = true

func _repeat_Flagged():
	if typeof(node_id) == TYPE_STRING:
		if node_id == "repeat":
			node_id = real_id
			$"Repeat flag".visible = false
		else:
			$"First flag".visible = false
			node_id = "repeat"
			$"Repeat flag".visible = true
	else:
		if typeof(node_id) == TYPE_INT:
			node_id = "repeat"
			$"Repeat flag".visible = true

func _add_name(name):
	nameList.add_item(name)

func _edit_name(id, to):
	nameList.set_item_text(id, to)

func _remove_name(id):
		nameList.remove_item(id)
