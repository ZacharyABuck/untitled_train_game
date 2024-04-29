# Hurtbox Component is just there to connect a Hurtbox (Collision)
# with the Health Component. The Health Component does all the heavy lifting.
# No customization of this component is needed. Just give it a Collision (Hurtbox).

extends Area2D
class_name HurtboxComponent

@export var health_component : HealthComponent
@export var hurt_sfx: AudioStreamPlayer

func damage(attack: Attack):
	if health_component:
		health_component.damage(attack)
		play_sfx()

func play_sfx():
	if hurt_sfx and !hurt_sfx.playing:
		hurt_sfx.call_deferred("play")
