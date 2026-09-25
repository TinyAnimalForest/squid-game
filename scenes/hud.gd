extends CanvasLayer

# Notifies `Main` node that the button has been pressed
signal start_game
var tween: Tween

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	
func show_game_over(high_score: int, new_high_score: bool):
	if new_high_score:
		show_message("Game Over\nNew High Score: " + str(high_score))
	else:
		show_message("Game Over\nCurrent High Score: " + str(high_score))
	
	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout

	$Message.text = "Dodge the Creeps!"
	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()

func update_score(score):
	$ScoreLabel.text = str(score)

func _on_start_button_pressed():
	$StartButton.hide()
	start_game.emit()

func _on_message_timer_timeout():
	$Message.hide()

func _on_start_button_mouse_entered() -> void:
	reset_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property($StartButton, "scale", Vector2(1.1, 1.1), 0.4)

func _on_start_button_mouse_exited() -> void:
	reset_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property($StartButton, "scale", Vector2.ONE, 0.4)

func reset_tween() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
