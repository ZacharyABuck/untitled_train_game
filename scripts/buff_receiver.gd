extends Area2D

var active_buffs: Array = []
var attack_delay_bonus: float = 0

func toggle_poison_fx(on: bool):
	if on:
		$PoisonTurretFX.emitting = true
	else:
		$PoisonTurretFX.emitting = false

func toggle_shock_fx(on: bool):
	if on:
		$ShockTurretFX.emitting = true
	else:
		$ShockTurretFX.emitting = false
