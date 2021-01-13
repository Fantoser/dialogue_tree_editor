tool
extends Control
	#var applicationName = ProjectSettings.get("application/config/name")
	#print(applicationName)
	#applicationName = ProjectSettings.get("application/config/name") + "Unsaved"
	#print(applicationName)
	#ProjectSettings.set("application/config/name", applicationName)
onready var Graph = get_node("HBoxContainer/VBoxContainer4/GraphEdit")
var text_node = preload("res://addons/open_dialogue_editor/Nodes/Text.tscn")
var divert_node = preload("res://addons/open_dialogue_editor/Nodes/Divert.tscn")
var question_node = preload("res://addons/open_dialogue_editor/Nodes/Question.tscn")
var action_node = preload("res://addons/open_dialogue_editor/Nodes/Action.tscn")
var random_node = preload("res://addons/open_dialogue_editor/Nodes/Random.tscn")
#const savebar_object = preload("res://addons/open_dialogue_editor/Objects/SaveBar.tscn")
var initial_position = Vector2(50, 50)
var node = null
var node_index = 0
var node_offset = 0
var dialogue = {}
var next_value = "next"
var save_file
var export_file
var mode = ""
var firstNode = ""
var changed = false

onready var nameInput = $HBoxContainer/VBoxContainer/Namelist_container/TextEdit
onready var nameList = $HBoxContainer/VBoxContainer/Namelist_container/NameList


func _ready():
	nameList.clear()
	nameList.add_item("")

func _process(delta):
	if save_file == null:
		$HBoxContainer/VBoxContainer4/HBoxContainer/Filename.text = "New dialogue"
	else:
		var filename = str(save_file.rsplit("/", false)[-1])
		if changed == true:
			$HBoxContainer/VBoxContainer4/HBoxContainer/Filename.text = "(*)" + filename
		else:
			$HBoxContainer/VBoxContainer4/HBoxContainer/Filename.text = filename
	if Input.is_action_just_pressed("button1"):
		print($GraphEdit.get_connection_list())
		for k in $GraphEdit.get_children():
			if k is GraphNode:
				print(str(k.real_id) + " | " + str(k.node_id))
		print("__________")


func _on_Text_node_pressed():
	node = text_node.instance()
	add_node(node)


func _on_Divert_node_pressed():
	node = divert_node.instance()
	add_node(node)


func _on_Question_node_pressed():
	node = question_node.instance()
	add_node(node)


func _on_Action_node_pressed():
	node = action_node.instance()
	add_node(node)


func _on_Random_node_pressed():
	node = random_node.instance()
	add_node(node)


func add_node(node):
	node.node_id = node_index
	node.offset += Graph.get_scroll_ofs() + (Graph.rect_size/3) + (node_offset * Vector2(40, 40))
	if mode != "load":
		node.title = str(node_index) + " " + node.title
	Graph.add_child(node)
	if node.Type != "divert":
		_load_namelist(node)
	node_index += 1
	node_offset += 1

func _on_GraphEdit_connection_request(from, from_slot, to, to_slot):
	Graph.connect_node(from, from_slot, to, to_slot)


func _on_GraphEdit_disconnection_request(from, from_slot, to, to_slot):
	Graph.disconnect_node(from, from_slot, to, to_slot)


func _on_GraphEdit_scroll_offset_changed(ofs):
	node_offset = 0

func _on_New_pressed(filename = null):
	for element in Graph.get_children():
		if element is GraphNode:
			element.queue_free()
	nameList.clear()
	nameList.add_item("")
	node_index = 0
	node_offset = 0
	dialogue = {}
	save_file = filename

func _on_Save_pressed():
	
	mode = "save"
	var connectlist = Graph.get_connection_list()
	var file = File.new()
	if save_file == null:
		var selector = FileDialog.new()
		selector.add_filter("*.json")
		selector.set_title("Save file")
		selector.set_mode(selector.MODE_SAVE_FILE)
		selector.set_access(selector.ACCESS_FILESYSTEM)
		self.add_child(selector)
		print("FILE IS NULL, OPENING OR CREATING ONE...")
		selector.popup_centered(Vector2(600,400))
		save_file = yield(selector,"file_selected")
		print(selector.current_dir)
	if file.open(save_file, file.WRITE) == OK:
		write_dialogue(connectlist)
		dialogue["connectlist"] = connectlist
		for i in range(0, dialogue["connectlist"].size()):
			dialogue["connectlist"][i]["from"] = Graph.get_node(connectlist[i]["from"]).node_id
			dialogue["connectlist"][i]["to"] = Graph.get_node(connectlist[i]["to"]).node_id
		file.store_string(JSON.print(dialogue))
		file.close()
		changed = false
#		add_savebar()
	else:
		print("ERROR")


func _on_Load_pressed():
	mode = "load"
	var selector = FileDialog.new()
	selector.add_filter("*.json")
	selector.set_mode(selector.MODE_OPEN_FILE)
	selector.set_access(selector.ACCESS_FILESYSTEM)
	self.add_child(selector)
	selector.popup_centered(Vector2(600,400))
	save_file = yield(selector,"file_selected")
	var file = File.new()
	if file.open(save_file,file.READ) == OK:
		_on_New_pressed(save_file)
		if JSON.parse(file.get_as_text()):
			dialogue = JSON.parse(file.get_as_text()).result
			for i in dialogue:
				if i != "connectlist":
					match dialogue[i]["type"]:
						"text":
							node = text_node.instance()
						"divert":
							node = divert_node.instance()
						"question":
							node = question_node.instance()
						"action":
							node = action_node.instance()
						"random":
							node = random_node.instance()
					add_node(node)
					node.node_id = i
					node.real_id = dialogue[i]["real_id"]
					if firstNode == "":
						firstNode = i
					if dialogue[i].has("real_id"):
						node.title = String(node.real_id) + " " + node.title
						if i == "first":
							node.node_id = node.real_id
							node._first_Flagged()
						if i == "repeat":
							node.node_id = node.real_id
							node._repeat_Flagged()
					else:
						node.title = i + " " + node.title
					if int(i) > node_index:
						node_index = int(i)+1
					if dialogue[i].has("name"):
						var namelist = $"HBoxContainer/VBoxContainer/Namelist_container/NameList"
						if namelist.get_item_count() == 1:
							namelist.add_item(dialogue[i]["name"])
							node._add_name(dialogue[i]["name"])
						else:
							for k in range(1, namelist.get_item_count()+1):
								if k == namelist.get_item_count():
									namelist.add_item(dialogue[i]["name"])
									node._add_name(dialogue[i]["name"])
								if namelist.get_item_text(k) == dialogue[i]["name"]:
									break
					node.loading(dialogue[i], i)
					if dialogue.has("connectlist"):
						node.offset = Vector2(dialogue[i]["offsetx"], dialogue[i]["offsety"])

			if dialogue.has("connectlist"):
				for i in range(0, dialogue["connectlist"].size()):
					var from = null
					var to = null
					for k in Graph.get_children():
						if k is GraphNode:
							if String(k.node_id) == String(dialogue["connectlist"][i]["from"]):
								from = k.name
							if String(k.node_id) == String(dialogue["connectlist"][i]["to"]):
								to = k.name
					var from_port = dialogue["connectlist"][i]["from_port"]
					var to_port = dialogue["connectlist"][i]["to_port"]
					Graph.connect_node(from, from_port, to, to_port)
			else:
				_connect_Nodes()
	mode = null

func _connect_Nodes():
	var placed = []
	var offset = Graph.get_scroll_ofs() + (Graph.rect_size/3)
	var from_node
	var to_node
	for node in Graph.get_children():
		if node is GraphNode:
			if node.node_id == firstNode:
				from_node = node
			if node.node_id == dialogue[firstNode].next:
				to_node = node
	Graph.connect_node(from_node.name, 0, to_node.name, 0)

func _on_Export_pressed():
	mode = "export"
	var graphs = Graph.get_children()
	var connectlist = Graph.get_connection_list()
	var file = File.new()
	if export_file == null:
		var selector = FileDialog.new()
		selector.add_filter("*.json")
		selector.set_title("Save file")
		selector.set_mode(selector.MODE_SAVE_FILE)
		selector.set_access(selector.ACCESS_FILESYSTEM)
		self.add_child(selector)
		print("FILE IS NULL, OPENING OR CREATING ONE...")
		selector.popup_centered(Vector2(600,400))
		export_file = yield(selector,"file_selected")
	if file.open(export_file, file.WRITE) == OK:
		write_dialogue(connectlist)
		file.store_string(JSON.print(dialogue))
		file.close()
	else:
		print("ERROR")


func write_dialogue(connectlist):
	dialogue = {}
	for i in range(0, connectlist.size()):

		var node = Graph.get_node(connectlist[i].from)
		var from_port = connectlist[i].from_port
		var to_node = Graph.get_node(connectlist[i].to)

		if dialogue.has(node.node_id) == false:
			dialogue[node.node_id] = {}

		if node.Type == "question" or node.Type == "random":
			if node.Type == "question":
				next_value = "next"
			if node.Type == "random":
				next_value = "value"
			if dialogue[node.node_id].has(next_value) == false:
				dialogue[node.node_id][next_value] = []
			dialogue[node.node_id][next_value].append("")

		node_read(node, from_port, to_node)

		if i+1 == connectlist.size() or node.Type == "divert" or node.Type == "question" or node.Type == "random":
			dialogue[to_node.node_id] = {}
			node_read(to_node)

	for node in Graph.get_children():
		if node is GraphNode:
			if dialogue.has(node.node_id) == false:
				print("DOH I MISSED " + String(node.node_id) + "!")
				dialogue[node.node_id] = {}
				node_read(node)


func node_read(node, from_port = null, to_node = null):
	var id = node.node_id
	
	dialogue[id]["real_id"] = node.real_id
	
	dialogue[id]["type"] = node.Type
	
	if node.get("Name"):
		if node.Name != "":
			dialogue[id]["name"] = node.Name
			dialogue[id]["position"] = "left"

	if node.get("Text"):
		if node.Text != "":
			dialogue[id]["content"] = node.Text

	if node.get("Operation"):
		dialogue[id]["operation"] = node.Operation

	if node.get("Condition"):
		if mode == "export":
			dialogue[id]["condition"] = node.Condition
		if mode == "save":
			dialogue[id]["condition"] = node.CondID
			
	if node.get("Dict"):
		if node.Dict != "":
			dialogue[id]["dictionary"] = node.Dict

	if node.get("Variable"):
		if node.Variable != "":
			dialogue[id]["variable"] = node.Variable

	if node.get("Value"):
		if node.Value != null:
			dialogue[id]["value"] = node.Value

	if node.get("Options"):
		dialogue[id]["options"] = node.Options.values()

	if mode == "save":
		dialogue[id]["offsetx"] = node.get_offset()[0]
		dialogue[id]["offsety"] = node.get_offset()[1]

	if to_node != null:
		match node.Type:
			"text", "action":
				dialogue[node.node_id]["next"] = String(to_node.node_id)
				continue
			"action":
				if mode == "save":
					dialogue[node.node_id]["slot_count"] = node.slots_count-4
			"divert":
				if from_port == 0:
					dialogue[node.node_id]["true"] = to_node.node_id
				if from_port == 1:
					dialogue[node.node_id]["false"] = to_node.node_id
			"question", "random":
				dialogue[node.node_id][next_value][from_port] = String(to_node.node_id)
				if mode == "save":
					dialogue[node.node_id]["slots_count"] = node.slots_count-4

	if mode == "export" and node.Type == "random":
		dialogue[node.node_id]["type"] = "action"

func _create_and_connect(from_node, type):
	match type:
		"text":
			node = text_node.instance()
		"divert":
			node = divert_node.instance()
		"question":
			node = question_node.instance()
		"action":
			node = action_node.instance()
		"random":
			node = random_node.instance()

	node.node_id = node_index
	Graph.add_child(node)
	if node.Type != "divert":
		_load_namelist(node)
	node.title = str(node_index) + " " + node.title
	node.offset = from_node.offset + Vector2(420, 0)
	Graph.connect_node(from_node.name , 0, node.name, 0)
	node_index += 1


func _on_Add_pressed():
	nameList.add_item(nameInput.text)
	_add_nodes_namelist(nameInput.text)
	nameInput.text = ""


func _on_Edit_pressed():
	if (nameInput.text != "") && (nameList.get_selected_items().size() != 0):
		_edit_nodes_namelist(nameList.get_selected_items()[0], nameInput.text)
		nameList.set_item_text(nameList.get_selected_items()[0], nameInput.text)
		nameInput.text = ""


func _on_Remove_pressed():
	if nameList.is_anything_selected() && nameList.get_selected_items()[0] != 0:
		_remove_nodes_namelist(nameList.get_selected_items()[0])
		nameList.remove_item(nameList.get_selected_items()[0])


func _add_nodes_namelist(name):
	if Graph.get_child_count() > 0:
		for node in Graph.get_children():
			if node is GraphNode and node.Type != "divert":
				node._add_name(name)


func _edit_nodes_namelist(id, to):
	for node in Graph.get_children():
		if node is GraphNode and node.Type != "divert":
			node._edit_name(id, to)


func _remove_nodes_namelist(id):
	for node in Graph.get_children():
		if node is GraphNode and node.Type != "divert":
			node._remove_name(id)


func _load_namelist(node):
	for i in range(nameList.get_item_count()):
		node._add_name(nameList.get_item_text(i))
		node.Name = nameList.get_item_text(0)

#func add_savebar(): # the saving bar that gets plopped in when something is saved
#	var savebar = savebar_object.instance()
#	get_parent().add_child(savebar)
#	var screenSize = Vector2(0,0)
#	screenSize.x = (get_viewport().get_visible_rect().size.x / 2) - (340 / 2)# Get Width
#	screenSize.y = (get_viewport().get_visible_rect().size.y / 2) - (100 / 2)# Get Height
#	savebar.set_position(screenSize)


func _on_First_pressed():
	for node in Graph.get_children():
		if node is GraphNode:
			if node.is_selected() == true:
				node._first_Flagged()
				continue
			if typeof(node.node_id) == TYPE_STRING:
				if node.node_id == "first":
					node._first_Flagged()


func _on_Repeat_pressed():
	for node in Graph.get_children():
		if node is GraphNode:
			if node.is_selected() == true:
				node._repeat_Flagged()
				continue
			if typeof(node.node_id) == TYPE_STRING:
				if node.node_id == "repeat":
					node._repeat_Flagged()
