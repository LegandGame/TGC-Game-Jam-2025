class_name HealthComponent extends Node

@export var maxHealth : float
@onready var curHealth : float = maxHealth

signal cur_health_changed(new_cur_health)
signal max_health_changed(new_max_health)
signal health_empty

func clamp_health() -> void:
	curHealth = clamp(curHealth, 0, maxHealth)

func get_cur_health() -> float:
	return curHealth
func get_max_health() -> float:
	return maxHealth


func reset_health() -> void:
	curHealth = maxHealth
	cur_health_changed.emit(curHealth)


# used for when we want to directly set the health value
func set_cur_health(new_value : float) -> void:
	curHealth = new_value
	if curHealth <= 0:
		health_empty.emit()
	clamp_health()
	cur_health_changed.emit(curHealth)

func set_max_health(new_value : float, alter_cur : bool = false) -> void:
	var diff = maxHealth - new_value
	maxHealth = new_value
	clamp_health()
	if alter_cur:
		curHealth += diff
		clamp_health()
		cur_health_changed.emit(curHealth)
	if curHealth <= 0 or maxHealth <= 0:
		health_empty.emit()
	max_health_changed.emit(maxHealth)


# for when we want to change health by a specified amount
func change_cur_health(difference : float) -> void:
	curHealth += difference
	clamp_health()
	if curHealth <= 0:
		health_empty.emit()
	cur_health_changed.emit(curHealth)

func change_max_health(difference : float, alter_cur : bool = false) -> void:
	maxHealth += difference
	clamp_health()
	if alter_cur:
		curHealth += difference
		clamp_health()
		cur_health_changed.emit(curHealth)
	if curHealth <= 0 or maxHealth <= 0:
		health_empty.emit()
	max_health_changed.emit(maxHealth)
