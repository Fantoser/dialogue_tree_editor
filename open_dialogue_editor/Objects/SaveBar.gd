extends ProgressBar

func _on_Timer_timeout() -> void:
	self.value = self.value + 1
	if (self.value == 9) :
		$Label.text = "Saved!"
	if (self.value == 10) :
		queue_free()

# It actually does nothing, other than self deletion.
# If you want to see where things is actually saved please look at the Main.gd located in the root folder
# And ctrl+f the following 'func _on_Save_pressed():' 
# Best of luck Code Monkey.
