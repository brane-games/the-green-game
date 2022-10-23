tool
extends MeshInstance


export (String, 
"the_golden_hour", 
"sunlight_on_the_coast", 
"september_moonrise", 
"pragser_wildsee_mit_dem_seekofel_tirol", 
"olive_trees_near_olevano", 
"marina_notturna", 
"green_wheat_fields_auvers", 
"edge_of_the_forest_sun_setting", 
"chestnut_trees_in_bloom", 
"saleve",
"bois_tailler_en_automne", 
"a_gorge_in_the_mountains", 
"the_beach_at_filey_in_yorkshire_england", 
"seascape_with_crushing_surf",
"mer_montane_a_veulettes",
"sunset_on_the_coast_of_capri",
"maine_coast_moonlight") var picture_name setget set_painting, get_painting


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func set_painting(val):
	picture_name = val
	var painting = load("res://sprites/paintings/" + picture_name + ".jpg")
	var material = self.get_active_material(0).duplicate()
	material.albedo_texture = painting
	self.set_surface_material(0, material)


func get_painting():
	return picture_name
