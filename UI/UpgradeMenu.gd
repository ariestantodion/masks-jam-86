#UpgradeMenu.gd
extends Control

@onready var speed_label: Label = $Panel/VBox/Speed/SpeedInfoLabel
@onready var invis_label: Label = $Panel/VBox/Invisibility/InvisInfoLabel
@onready var msg_label: Label = $Panel/VBox/MessageLabel
@onready var speed_btn: Button = $Panel/VBox/Speed/SpeedButton
@onready var invis_btn: Button = $Panel/VBox/Invisibility/InvisButton
@onready var close_btn: Button = $Panel/VBox/CloseButton


func _ready() -> void:
	visible = false
	speed_btn.pressed.connect(_on_speed_upgrade)
	invis_btn.pressed.connect(_on_invis_upgrade)
	close_btn.pressed.connect(self._on_close)
	_update_info()


func open() -> void:
	visible = true
	_update_info()
	speed_btn.grab_focus()


func close_menu() -> void:
	visible = false


func _on_close() -> void:
	close_menu()


func _update_info() -> void:
	speed_label.text = "Level: %d | Cost: %d" % [
		MaskManager.speed_level,
		MaskManager.SPEED_COST
	]
	invis_label.text = "Level: %d | Cost: %d" % [
		MaskManager.invisibility_level,
		MaskManager.INVIS_COST
	]


func _on_speed_upgrade() -> void:
	var result: bool = MaskManager.upgrade_speed()
	if result:
		msg_label.text = "Speed upgraded!"
	else:
		msg_label.text = "Not enough candy or max level."
	_update_info()


func _on_invis_upgrade() -> void:
	var result: bool = MaskManager.upgrade_invisibility()
	if result:
		msg_label.text = "Invisibility upgraded!"
	else:
		msg_label.text = "Not enough candy or max level."
	_update_info()
