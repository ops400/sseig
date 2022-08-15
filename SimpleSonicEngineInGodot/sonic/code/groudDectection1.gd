extends Area2D

func _on_groudDectection1_body_entered(body):
	globalVars.sonicGroundedR = true

func _on_groudDectection1_body_exited(body):
	globalVars.sonicGroundedR = false
