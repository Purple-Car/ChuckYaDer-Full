extends Node

func boolToSign(to_transform: bool) -> int:
	return 1 - 2 * int(to_transform)

func check() -> void:
	if true: return
	elif false: return
