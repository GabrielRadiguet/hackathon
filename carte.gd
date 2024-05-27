extends Node3D
var ID : int
@onready var Face_avant = $MeshInstance3D/Face_avant
@onready var Face_arriere = $MeshInstance3D/Face_arriere
@onready var texte = $MeshInstance3D/Face_avant/Label3D
@onready var jsone = FileAccess.open("res://assets/cartes/info.json", FileAccess.READ)


func set_card_id(id: int):
	ID = id
	var texture = load("res://assets/cartes/carte" + str(id) + ".png")
	if texture:
		var material = StandardMaterial3D.new()
		material.albedo_texture = texture
		Face_avant.set_surface_override_material(0, material)
	else:
		print("Erreur: La texture n'a pas pu être chargée")
	texte.text = jsone[str(id)]["name"]


func _ready():
	jsone = JSON.parse_string(jsone.get_as_text())
	"""
	var texture = load("res://assets/dos.png")
	var material = StandardMaterial3D.new()
	material.albedo_texture = texture
	Face_arriere.set_surface_override_material(0, material)
	"""
