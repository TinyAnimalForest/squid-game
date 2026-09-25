extends Node

@export var mob_scene: PackedScene
var score: int = 0
var high_score: int = 0
var new_high_score: bool

func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.update_score(score)
	$HUD.show_game_over(high_score,new_high_score)
	get_tree().call_group("mobs", "queue_free")

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	new_high_score = false
	$HUD.show_message("Get Ready")

func _on_mob_timer_timeout() -> void:
		# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()
	mob.add_to_group("mobs")

	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's position to the random location.
	mob.position = mob_spawn_location.position
	
	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)


func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)
	if score > high_score:
		high_score = score
		new_high_score = true

func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#new_game()
	$ScoreTimer.stop()
	#pass
