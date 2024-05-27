extends Node3D
var camera: Camera3D
@onready var gridmap = $GridMap

var card_scene = preload("res://carte.tscn")
var select = null
var select_id = null
var initialized = false

func find_camera(node: Node) -> Camera3D:
	if node is Camera3D:
		return node as Camera3D
	for child in node.get_children():
		var camera = find_camera(child)
		if camera:
			return camera
	return null

func _ready():
	camera = find_camera(get_tree().root)
	initialized = true

func _physics_process(delta):
	if not initialized:
		return
	var mouse_pos_cast = cast_mouse_position()
	var maxi = [1,null]
	var cartes = gridmap.get_children()
	if mouse_pos_cast :
		var diff
		for i in range(len(cartes)) :
			diff = cartes[i].global_position.distance_to(mouse_pos_cast.position)
			if i == select :
				diff = min(diff,(cartes[i].global_position+Vector3(0,-0.2,0.2)).distance_to(mouse_pos_cast.position))
			if diff < 0.25 and maxi[0] > diff:
				maxi = [diff,i]

	var centre = max(float(len(cartes)/2),1)
	if select != null and select < len(cartes):
		if len(cartes) == 1 :
			cartes[0].set_position(Vector3(0,0,0))
			cartes[0].set_rotation_degrees(Vector3(0,90,0))
		else :
			var card_angle = ((-select+centre)/ (centre)) * 15
			cartes[select].set_rotation_degrees (Vector3(0, 90+card_angle,0))
			cartes[select].set_position(Vector3((select-centre)/2.5,0,abs(card_angle)/160))
	if maxi[1] != null:
		if len(cartes) == 1 :
			cartes[0].set_position(Vector3(0,0,-0.2))
			cartes[0].set_rotation_degrees(Vector3(0,90,0))
		else :
			var card_angle = ((-(maxi[1])+centre)/ (centre)) * 15
			cartes[maxi[1]].set_rotation_degrees (Vector3(0, 90+card_angle,0))
			cartes[maxi[1]].set_position(Vector3((maxi[1]-centre)/2.5,0,(abs(card_angle)/160)-0.2))
		select_id = cartes[maxi[1]].ID
	select = maxi[1]


func cast_mouse_position() : 
	var mouse_pos = get_viewport().get_mouse_position()

	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * 1000.0

	var space_state = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.from = from
	ray_query.to = to
	ray_query.collide_with_areas = true
	ray_query.collide_with_bodies = true
	var intersection = space_state.intersect_ray(ray_query)
	if intersection :
		return intersection
	else : 
		return null
	
func add_card(id):
	var card = card_scene.instantiate()
	gridmap.add_child(card)
	card.set_card_id(id)
	Variables.cartes.append([id])
	update_cards()
	
func remove_card(id):
	var cards = gridmap.get_children()
	for c in cards :
		if c.name.contains("Node3D") and c.ID == id :
			Variables.cartes.erase([id])
			#remove_child(c)
			c.queue_free()
			await get_tree().process_frame
			update_cards()
			break


	
func update_cards(carte = gridmap.get_children()):
	
	if len(carte) == 1 :
		carte[0].set_position(Vector3(0,0,0))
		carte[0].set_rotation_degrees(Vector3(0,90,0))
		return
		
	var centre = float((len(carte))/2)
	for i in range(len(carte)):
		var card_angle = ((-i+centre)/ (centre)) * 15
		carte[i].set_rotation_degrees (Vector3(0, 90+card_angle,0))
		carte[i].set_position(Vector3((i-centre)/2.5,0,abs(card_angle)/160))

