extends GraphNode

var node_id = 0
var slots_count = 1

# Called when the node enters the scene tree for the first time.
#func _ready():
 

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	$TextEdit.rect_size[1] = self.rect_size[1]-50


func _on_Test_node_close_request():
	queue_free()


func _on_Test_node_resize_request(new_minsize):
	rect_size = new_minsize


#func _on_Test_node_resized():
#	$VBoxContainer.rect_min_size.y = self.get_rect().size.y - 45


func _on_Button_pressed():
	var container = VBoxContainer.new()
	var textbar = TextEdit.new()

	container.rect_min_size[1] = 30
	container.set_v_size_flags(SIZE_EXPAND_FILL)
	textbar.set_v_size_flags(SIZE_EXPAND_FILL)
	
	slots_count += 1
	set_slot(slots_count, true, 0, Color(1, 1, 1, 1), true, 0, Color(1, 1, 1, 1))

	container.add_child(HSeparator.new())
	container.add_child(textbar)
	self.add_child(container)


func _on_Button2_pressed():
	if slots_count > 1:
		self.get_child(get_child_count()-1).queue_free()
		slots_count -= 1
	
