extends Node

func take_damage(enemy, amount):
	enemy.health -= amount
	if enemy.health <= 0:
		PlayerInfo.money += enemy.money
		enemy.queue_free()
