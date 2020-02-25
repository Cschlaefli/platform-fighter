extends CanvasLayer

var ingame_player : IngamePlayer

func _physics_process(delta):
	if ingame_player :
		$Control/Stats/Name.text = ingame_player.display_name
		$Control/Stats/Stocks.text =  "stocks :" + str(ingame_player.lives)
		if ingame_player.live_character :
			$Control/Stats/Damage.text = "damage : " + str(ingame_player.live_character.damage)



