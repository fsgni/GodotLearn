extends Node

var score = 0 setget set_score

onready var scoreLabel = $ScoreLabel

func set_score(value):
	score = value
	update_score_labal()

func update_score_labal():
	scoreLabel.text = "Score = " + str(score)
	
func update_save_data():
	var save_data = SaveAndLoad.load_data_from_file()
	if score > save_data.highscore:
		save_data.highscore = score
		SaveAndLoad.save_data_to_file(save_data)
	

func _on_Ship_player_death(): #通过玩家死亡来打开gameover的场景
	update_save_data()
	yield (get_tree().create_timer(1), "timeout")
	get_tree().change_scene("res://GameOverScreen.tscn")
