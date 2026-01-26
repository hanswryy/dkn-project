extends Node2D

@onready var monodialog_ui = $MonodialogUI

var trigger: Node = null

func start_monodialog(character, text = "", options = {}):
	print("Entered manager")
	trigger = character
	if text != "":
		monodialog_ui.show_monodialog(character.start_duration, character.character_name, text, options)
	else:
		var monodialog = trigger.get_current_monodialog()
		if not monodialog:
			return
		monodialog_ui.show_monodialog(character.start_duration, character.character_name, monodialog["text"], monodialog["options"])

func stop_monodialog(duration):
	monodialog_ui.hide_monodialog(duration)

func handle_monodialog_choices(option):
	var current_monodialog = trigger.get_current_monodialog()
	if not current_monodialog: return
	var options = current_monodialog.get("options", {})
	var next_state = options.get(option, "start")
	trigger.set_monodialog_state(next_state)
	if next_state == "end":
		if trigger.current_branch_index < trigger.monodialog_resource.get_chara_monodialog(trigger.character_id).size() - 1:
			trigger.set_monodialog_tree(trigger.current_branch_index + 1)
		stop_monodialog(trigger.hide_duration)
	elif next_state == "exit":
		trigger.set_monodialog_state("start")
		stop_monodialog(trigger.hide_duration)
	else:
		start_monodialog(trigger)
