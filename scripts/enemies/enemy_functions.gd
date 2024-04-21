extends Node

# This method is no longer needed. Unsure what functions will end up in here!
func take_damage(enemy, amount):
	enemy.health -= amount
	if enemy.health <= 0:
		PlayerInfo.current_money += enemy.money
		enemy.queue_free()
		for i in EnemyInfo.enemy_inventory:
			if EnemyInfo.enemy_inventory[i] == enemy:
				EnemyInfo.enemy_inventory.erase(i)
