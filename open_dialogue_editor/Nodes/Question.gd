tool
extends GraphNode

onready var parent = self.get_parent()

var node_id = 0
var real_id = 0
var Type = "question"
var Name = ""
var Text = ""
var Options = {}
var slots_count = 5
var slot_id = 0
var slots_height = 40
var textbar = null
var const_size = null

onready var nameList = $"All/Name container/Name text"


func _ready():
	real_id = node_id
	rect_min_size.y = 253
	rect_size.y = 253
	$All.rect_min_size.y = 160
	_on_Add_pressed()
#	_All_resize()


func _process(delta):
	if rect_size.y > 253 + ((slots_count-5)*35):
		emit_signal("resized")


func loading(node):
	if node.has("name"):
		Name = node["name"]

	if node.has("content"):
		$"All/Text text".text = node["content"]
		Text = node["content"]

	textbar.text = node["options"][0]
	Options[0] = node["options"][0]

	for i in range(1, node["slots_count"]):
		_on_Add_pressed()
		textbar.text = node["options"][i]
		Options[i] = node["options"][i]


func _on_Question_node_close_request():
	queue_free()


#func _on_Question_node_resize_request(new_minsize):
#	rect_size = new_minsize
#	const_size = new_minsize


func _on_Question_node_resized():
	rect_size.y = rect_min_size.y
	rect_size.x = 333
#	_All_resize()

func _All_resize():
#	var removeHeight = $Firstrepeat.rect_size.y + $"Button container".rect_size.y + (slots_count*slots_height)
#	if self.get_rect().size.y - removeHeight > 30:
#		$"All".rect_min_size.y = (self.get_rect().size.y) - removeHeight
#	else:
#		$"All".rect_min_size.y = 30
	$"All".rect_min_size.y = 30

func _on_Add_pressed():
#	self.rect_min_size.y += 40
	Options[str(slot_id)] = ""

	var container = VBoxContainer.new()
	var btnBar = HBoxContainer.new()
	textbar = TextEdit.new()
	var removeBtn = Button.new()

	removeBtn.text = "-"
	removeBtn.set_focus_mode(0)
	removeBtn.connect("button_down", self, "_option_Remove", [container, slot_id])

	textbar.connect("text_changed", self, "_option_Change", [textbar, slot_id])

	container.rect_size.y = 40
	container.set_v_size_flags(SIZE_EXPAND_FILL)
	textbar.set_v_size_flags(SIZE_EXPAND_FILL)
	textbar.set_h_size_flags(SIZE_EXPAND_FILL)

	slots_count += 1
	set_slot(slots_count, false, 0, Color(1, 1, 1, 1), true, 0, Color(1, 1, 1, 1))

	btnBar.add_child(removeBtn)
	btnBar.add_child(textbar)
	container.add_child(HSeparator.new())
	container.add_child(btnBar)
	self.add_child(container)

	slot_id += 1


#func _on_Remove_pressed():
#	if slots_count > 5:
#		Options.pop_back()
##		self.rect_size.y -= 40
#		self.get_child(get_child_count()-1).queue_free()
#		slots_count -= 1
#	emit_signal("resized")


func _option_Change(node, slot_id):
	Options[str(slot_id)] = node.text

func _option_Remove(container, slot_id):
	container.queue_free()
	for connection in parent.get_connection_list():
		if connection["from"] == self.name:
			if connection["from_port"] == Options.keys().find(str(slot_id)):
				print(slot_id)
				print(Options.keys())
				print(Options.keys().find(str(slot_id)))
				parent.disconnect_node(connection["from"], connection["from_port"], connection["to"], connection["to_port"])
				_reconnect(Options.keys().find(str(slot_id)))
	Options.erase(str(slot_id))
	slots_count -= 1

func _reconnect(deleted_option):
	for connection in parent.get_connection_list():
		if connection["from"] == self.name:
			if connection["from_port"] > deleted_option:
				parent.disconnect_node(connection["from"], connection["from_port"], connection["to"], connection["to_port"])
				parent.connect_node(connection["from"], connection["from_port"]-1, connection["to"], connection["to_port"])

func _on_ID_text_text_changed():
	node_id = $"All/ID text".text

func _on_Name_text_text_changed():
	Name = $"All/Name text".text

func _on_Text_text_text_changed():
	Text = $"All/Text text".text

func _on_First_checkbox_pressed():
	if $"Firstrepeat/First/First checkbox".pressed == true:
		$"Firstrepeat/Repeat/Repeat checkbox".pressed = false
		node_id = "first"
	else:
		node_id = real_id

func _on_Repeat_checkBox_pressed():
	if $"Firstrepeat/Repeat/Repeat checkbox".pressed == true:
		$"Firstrepeat/First/First checkbox".pressed = false
		node_id = "repeat"
	else:
		node_id = real_id

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
