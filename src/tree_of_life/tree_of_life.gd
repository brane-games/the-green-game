tool
extends Spatial


export(float, 0,100) var lifeness = 0 setget set_life_strength, get_life_strength

# Called when the node enters the scene tree for the first time.
func _ready():
	call_deferred("_randomize_tree")
	$Tree/liana/StaticBody/SoftBody.hide()

var factor = 0.05
func set_life_strength(val):
	lifeness = val
	if($Tree/MultiMeshInstanceSparseLeaves):
		if(lifeness <= 1):
			$Flowers.hide()
			$Flowers2.hide()
		elif(lifeness <= 5):
			$Flowers2.show()
		elif(lifeness <= 10):
			$Flowers2.show()
			$Tree/MultiMeshInstanceSparseLeaves.multimesh.visible_instance_count = 0
			$Tree/MultiMeshInstanceSparseLeaves2.multimesh.visible_instance_count = 0
		elif(lifeness < 75):
			$Tree/MultiMeshInstanceSparseLeaves.multimesh.visible_instance_count = floor(lifeness-10)
			$Tree/MultiMeshInstanceSparseLeaves2.multimesh.visible_instance_count = floor(lifeness-10)
		elif(lifeness >= 75):
			$Tree/liana/StaticBody/SoftBody.show()
		$Tree/liana.get_active_material(0).emission_energy = lifeness * 0.06
		$Tree/MultiMeshInstanceManyLeaves.multimesh.visible_instance_count = floor(lifeness * 0.05)
		$Tree/MultiMeshInstanceManyLeaves2.multimesh.visible_instance_count = floor(lifeness * 0.05)
		
		

func get_life_strength():
	return lifeness

func _randomize_tree():
	for i in range($Tree/MultiMeshInstanceSparseLeaves.multimesh.instance_count):
		var position = Transform()
		position = position.rotated(Vector3(0, 1, 0), randf() * 6.28)
		position = position.rotated(Vector3(0, 0, 1), randf() * 0.28)
		position = position.rotated(Vector3(1, 0, 0), randf() * 0.28)
		$Tree/MultiMeshInstanceSparseLeaves.multimesh.set_instance_transform(i, position)
	for i in range($Tree/MultiMeshInstanceSparseLeaves2.multimesh.instance_count):
		var position = Transform()
		position = position.rotated(Vector3(0, 1, 0), randf() * 6.28)
		position = position.rotated(Vector3(0, 0, 1), randf() * 0.28)
		position = position.rotated(Vector3(1, 0, 0), randf() * 0.28)
		$Tree/MultiMeshInstanceSparseLeaves2.multimesh.set_instance_transform(i, position)
	for i in range($Tree/MultiMeshInstanceManyLeaves.multimesh.instance_count):
		var position = Transform()
		position = position.rotated(Vector3(0, 0, 1), randf() * 6.28)
		$Tree/MultiMeshInstanceManyLeaves.multimesh.set_instance_transform(i, position)
	for i in range($Tree/MultiMeshInstanceManyLeaves2.multimesh.instance_count):
		var position = Transform()
		position = position.rotated(Vector3(0, 0, 1), randf() * 6.28)
		$Tree/MultiMeshInstanceManyLeaves2.multimesh.set_instance_transform(i, position)
