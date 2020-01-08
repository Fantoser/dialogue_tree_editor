extends GraphNode

var node_id = 0
var real_id = 0
var Type = "divert"
var Condition = "boolean"
var CondID = 0
var Dict = ""
var Variable = ""
var Value = null
var const_size = null

onready var condition = $"All/Condition"
onready var dictionary = $"All/Dictionary text"
onready var variable = $"All/Variable text"
onready var value = $"All/Value text"


func _ready():
	real_id = node_id
	condition.add_item("boolean")
	condition.add_item("equal")
	condition.add_item("greater")
	condition.add_item("less")
	condition.add_item("range")
	const_size = rect_min_size
 


func _process(delta):
	rect_size = const_size
	

func loading(node):
	if node.had("dictionary"):
		$"All/Dictionary text".text = node["dictionary"]
		Dict = node["dictionary"]
	
	if node.has("variable"):
		$"All/Variable text".text = node["variable"]
		Variable = node["variable"]

	if node.has("value"):
		$"All/Value text".text = node["value"]
		Value = node["value"]

	condition.select(node["condition"])


func _on_Divert_node_close_request():
	queue_free()


func _on_Divert_node_resize_request(new_minsize):
	rect_size = new_minsize
	const_size = new_minsize


func _on_Divert_node_resized():
	$"All".rect_min_size.y = self.get_rect().size.y - 180


func _on_ID_text_text_changed():
	node_id = $"All/ID text".text


func _on_Condition_item_selected(ID):
	Condition = condition.get_item_text(ID)
	CondID = ID


func _on_Dictionary_text_text_changed():
	Dict = dictionary.text


func _on_Variable_text_text_changed():
	Variable = variable.text


func _on_Value_text_text_changed():
	Value = value.text


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