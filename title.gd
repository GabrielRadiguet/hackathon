extends Control
@onready var credit = $Popup
@onready var tuto = $Popup2
@onready var ecriture = $Popup/RichTextLabel
@onready var jsone = JSON.parse_string(FileAccess.open("res://assets/cartes/info.json", FileAccess.READ).get_as_text())
# Called when the node enters the scene tree for the first time.
func _ready():
	var a = "\n\n Les cartes choisies sont :\n"
	for elt in jsone :
		a += "- " + jsone[elt]['name'] + "\n"
	ecriture.text += a
	pass # Replace with function body.


func _on_niveau_1_pressed():
	Variables.difficile = 0
	get_tree().change_scene_to_file("res://main.tscn")



func _on_niveau_2_pressed():
	Variables.difficile = 1
	get_tree().change_scene_to_file("res://main.tscn")



func _on_tuto_pressed():
	credit.visible = true
	pass # Replace with function body.


func _on_credit_pressed():
	tuto.visible = true
	pass # Replace with function body.
