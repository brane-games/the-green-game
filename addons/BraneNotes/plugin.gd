tool
extends EditorPlugin

var dock
var file:File = File.new()
var newTabScene = preload("res://addons/BraneNotes/NoteTab.tscn")
var addNewTabButton
var tabContainer : TabContainer
var saveTimer : Timer
var saveJson : Dictionary

const savePath : String = "res://addons/BraneNotes/notes.json"

func _enter_tree() -> void:
	dock = preload("res://addons/BraneNotes/BraneNotes.tscn").instance()
	add_control_to_dock(DOCK_SLOT_RIGHT_UR, dock)
	tabContainer = dock.get_node("TabContainer")
	saveTimer = dock.get_node("SaveTimer")
	saveTimer.connect("timeout", self, "save_notes")
	addNewTabButton = dock.get_node("TabContainer/+")
	tabContainer.connect("tab_changed", self, "_handle_tab_changed")
	tabContainer.get_node("New Tab/HBoxContainer/TabTitleLineEdit").connect("text_changed", self, "change_current_tab_title")
	tabContainer.get_node("New Tab/textEdit").connect("text_changed", self, "change_current_tab_text")
	tabContainer.get_node("New Tab/HBoxContainer/DeleteTabButton").hide()
	load_notes()

func _exit_tree() -> void:
	remove_control_from_docks(dock)
	dock.queue_free()


func load_notes() -> void:
	if file.file_exists(savePath):
		file.open(savePath, File.READ)
		saveJson = JSON.parse(file.get_as_text()).result
	else:
		saveJson = JSON.parse('{"0":{ "Title": "First Tab", "Text": "Type here..." }}').result
	tabContainer.set_tab_title(0, saveJson['0'].Title)
	tabContainer.get_node("New Tab/textEdit").text = saveJson['0'].Text
	tabContainer.get_node("New Tab/HBoxContainer/TabTitleLineEdit").text = saveJson['0'].Title
	for i in range (1, saveJson.size()):
		_add_tab()
		tabContainer.set_tab_title(i, saveJson[str(i)].Title)
		tabContainer.get_child(i).get_node("HBoxContainer/TabTitleLineEdit").text = saveJson[str(i)].Title
		tabContainer.get_child(i).get_node("textEdit").text = saveJson[str(i)].Text

func save_notes() -> void:
	file.open(savePath, File.WRITE)
	file.store_string(JSON.print(saveJson))
	file.close()

func _text_change() -> void:
	file.open(savePath, File.WRITE)
	file.store_string(dock.get_node("textEdit").text)
	file.close()

func _handle_tab_changed(tab_id :int):
	#if it's the last tab then add one more tab
	if(tab_id == tabContainer.get_child_count() - 1):
		_add_new_tab()

func _add_new_tab():
	_add_tab()
	tabContainer.current_tab = tabContainer.get_child_count() - 2
	saveJson[str(tabContainer.current_tab)] = {}
	saveJson[str(tabContainer.current_tab)]["Title"] = "New Tab"
	saveJson[str(tabContainer.current_tab)]["Text"] = ""
	saveTimer.start()

func _add_tab():
	var newTab = newTabScene.instance()
	tabContainer.add_child(newTab)
	tabContainer.move_child(addNewTabButton, tabContainer.get_child_count() - 1)
	tabContainer.set_tab_title(tabContainer.get_child_count() - 2, "New Tab" )
	newTab.get_node("HBoxContainer/DeleteTabButton").connect("pressed", self, "_delete_current_tab")
	newTab.get_node("HBoxContainer/TabTitleLineEdit").connect("text_changed", self, "change_current_tab_title")
	newTab.get_node("textEdit").connect("text_changed", self, "change_current_tab_text")

func _delete_current_tab():
	if(tabContainer.get_child_count() > 2):
		saveJson.erase(str(tabContainer.current_tab))
		tabContainer.remove_child(tabContainer.get_child(tabContainer.current_tab))
		tabContainer.current_tab = 0
		saveTimer.start()

func change_current_tab_title(title):
	tabContainer.set_tab_title(tabContainer.current_tab, title)
	saveJson[str(tabContainer.current_tab)].Title = title
	saveTimer.start()

func change_current_tab_text():
	var current_txt = tabContainer.get_child(tabContainer.current_tab).get_node("textEdit").text
	saveJson[str(tabContainer.current_tab)].Text = current_txt
	saveTimer.start()
	
