extends Area2D

func _on_groudDectection2_body_entered(body):
	globalVars.sonicGroundedL = true 

func _on_groudDectection2_body_exited(body):
	globalVars.sonicGroundedL = false
