extends CanvasLayer

var ingame_player : IngamePlayer

func _physics_process(delta):
	if ingame_player :
		$Control/Panel/Stats/Name.text = ingame_player.display_name
		$Control/Panel/Stats/Stocks.text =  "Stocks :" + str(ingame_player.lives)
		if ingame_player.live_character :
			$Control/Panel/Stats/Damage.text = "Damage : " + str(ingame_player.live_character.damage)



