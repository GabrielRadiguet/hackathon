extends Node

@onready var deck = $deck
@onready var carte = $carte
@onready var jsone = FileAccess.open("res://assets/cartes/info.json", FileAccess.READ)
@onready var score_label = $CanvasLayer/Control/Label
@onready var pop_fin = $CanvasLayer/Control/Popup
var score = 10

# Called when the node enters the scene tree for the first time.

func _ready():
	Variables.cartes = []
	score_label.text = "Score: " + str(score)
	jsone = JSON.parse_string(jsone.get_as_text())
	
	var ep = {
		"Antiquite" :{
			"Politique" : 0,
			"Culturel" : 0,
			"Conflit" : 0,
			"Scientifique" : 0,
			"Religieux" : 0,
			"Economique et Social" : 0
		},
		"Moyen-age" : {
			"Politique" : 0,
			"Culturel" : 0,
			"Conflit" : 0,
			"Scientifique" : 0,
			"Religieux" : 0,
			"Economique et Social" : 0
		},
		"Moderne" :{
			"Politique" : 0,
			"Culturel" : 0,
			"Conflit" : 0,
			"Scientifique" : 0,
			"Religieux" : 0,
			"Economique et Social" : 0
		},
		"Contemporaine" :{
			"Politique" : 0,
			"Culturel" : 0,
			"Conflit" : 0,
			"Scientifique" : 0,
			"Religieux" : 0,
			"Economique et Social" : 0
		},
		}
	for i in range(len(jsone)):
		print(jsone[str(i+1)])
		ep[jsone[str(i+1)]["periode"]][jsone[str(i+1)]["theme"]] += 1
	print(ep)
	for i in range(5):
		var temp = true
		var new_id = 0
		while temp :
			new_id = (randi() % len(jsone)+1)
			if not (Variables.cartes.has([new_id])):
				temp = false
				
		deck.add_card(new_id)
	choose()

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1:
			if event.pressed:
				print("Left button was clicked at ", event.position)
			else:
				if deck.select != null :
					var id = deck.select_id
					if valide(id) :
						deck.remove_card(id)
						carte.set_card_id(id)
						if len(Variables.cartes) == 0 :
							fin()
							return
						choose()
					else :
						var new_id = randi() % len(jsone)+1
						var temp = true
						while temp :
							new_id = (randi() % len(jsone)+1)
							if not (Variables.cartes.has([new_id])) and new_id != carte.ID :
								temp = false
						deck.add_card(new_id)
						score -= 2
						score_label.text = "Score: " + str(score)

func valide(id) :
	if jsone[str(id)]["theme"] == jsone[str(carte.ID)]["theme"] or jsone[str(id)]["periode"] == jsone[str(carte.ID)]["periode"] :
		return true
	return false

func fin():
	var pop_up = $CanvasLayer/Control/Popup/RichTextLabel
	pop_up.text = "félicitation !\n Votre score est : " + str(score)
	pop_fin.visible = true
	await get_tree().create_timer(5).timeout
	get_tree().change_scene_to_file("res://title.tscn")
	pass

func choose():
	if Variables.difficile :
		var carte_pos = {}

		for i in range(1,len(jsone)+1):
			carte_pos[i] = 0

		for i in range(1,len(jsone)+1) :
			if not (Variables.cartes.has([i])) and carte.ID != i :
				for j in range(len(Variables.cartes)) :
					if jsone[str(Variables.cartes[j][0])]["theme"] == jsone[str(i)]["theme"] or jsone[str(Variables.cartes[j][0])]["periode"] == jsone[str(i)]["periode"] :
						print(j)
						carte_pos[i] += 1
		print(carte_pos)
		print(Variables.cartes)
		var min = 50
		var index = []
		for i in range(1,len(carte_pos)+1) :
			if carte_pos[i] != 0 :
				if carte_pos[i] < min :
					min = carte_pos[i]
					index = [i]
				elif carte_pos[i] == min :
					index.append(i)
		var choice = index[randi() % index.size()]
		print(choice)
		carte.set_card_id(choice)
	else :
		var carte_pos = []
		for i in range(1,len(jsone)+1) :
			if not (Variables.cartes.has([i])) and carte.ID != i :
				for j in range(len(Variables.cartes)) :
					if jsone[str(Variables.cartes[j][0])]["theme"] == jsone[str(i)]["theme"] or jsone[str(Variables.cartes[j][0])]["periode"] == jsone[str(i)]["periode"] :
						carte_pos.append(i)
						break
		
		var choice = carte_pos[randi() % carte_pos.size()]
		carte.set_card_id(choice)


func _on_quit_button_pressed():
	get_tree().change_scene_to_file("res://title.tscn")
