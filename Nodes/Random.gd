extends GraphNode

var node_id = 0
var real_id = 0
var Type = "random"
var Operation = "random"
var Name = ""
var Text = ""
var slots_count = 4
var all_miny = 105
var Value = []
var const_size = null

onready var nameList = $"All/Name text"

func _ready():
	real_id = node_id
	_on_Add_pressed()
	const_size = rect_min_size
 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rect_size = const_size
#	$TextEdit.rect_size[1] = self.rect_size[1]-50


func loading(node):
	if node.has("name"):
		$"All/Name text".text = node["name"]
		Name = node["name"]

	if node.has("content"):
		$"All/Text text".text = node["content"]
		Text = node["content"]

	for i in range(1, node["value"].size()):
		_on_Add_pressed()

func _on_Random_node_close_request():
	queue_free()


func _on_Random_node_resize_request(new_minsize):
	rect_size = new_minsize
	const_size = new_minsize


func _on_Random_node_resized():
	$"All".rect_min_size.y = self.get_rect().size.y - all_miny

func _on_Add_pressed():
	
	all_miny += 30
	self.rect_min_size[1] += 30
	
	var container = VBoxContainer.new()

#	textbar.connect("text_changed", self, "_variable_Change", [textbar, slots_count-5])
#	textbar2.connect("text_changed", self, "_value_Change", [textbar, slots_count-5])

	container.rect_min_size[1] = 30
	container.set_v_size_flags(SIZE_EXPAND_FILL)
#	textbar.set_v_size_flags(SIZE_EXPAND_FILL)
#	textbar2.set_v_size_flags(SIZE_EXPAND_FILL)

	slots_count += 1
	set_slot(slots_count, false, 0, Color(1, 1, 1, 1), true, 0, Color(1, 1, 1, 1))

	container.add_child(HSeparator.new())
#	container.add_child(textbar)
#	container.add_child(textbar2)
	self.add_child(container)


func _on_Remove_pressed():
	if slots_count > 1:
		all_miny -= 30
		self.rect_min_size[1] -= 30
		self.get_child(get_child_count()-1).queue_free()
		slots_count -= 1

func _on_Variable_check_pressed():
	if $"HBoxContainer/HBoxContainer2/Variable check".pressed == true:
		$"HBoxContainer/HBoxContainer3/Random check".pressed = false
	else:
		$"HBoxContainer/HBoxContainer2/Variable check".pressed = true


func _on_Random_check_pressed():
	if $"HBoxContainer/HBoxContainer3/Random check".pressed == true:
		$"HBoxContainer/HBoxContainer2/Variable check".pressed = false
	else:
		$"HBoxContainer/HBoxContainer3/Random check".pressed = true

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

func _add_name(name):
	nameList.add_item(name)

func _edit_name(id, to):
	nameList.set_item_text(id, to)

func _remove_name(id):
		nameList.remove_item(id)