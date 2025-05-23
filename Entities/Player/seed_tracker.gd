extends Node

var seedCount : int = 0

@onready var health : HealthComponent = $Health

func add_seed(amount : int = 1) -> void:
	seedCount += amount
	health.change_max_health(amount, true)

func remove_seed(amount : int = 1) -> void:
	if seedCount - amount < 0:
		print("debug: seed tracker error; tried to remove to many seeds")
		return
	seedCount -= amount
	health.change_max_health(-amount)

func set_seed_amount(new_count : int) -> void:
	seedCount = new_count
	health.set_max_health(3.0 + new_count, true)
