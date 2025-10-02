extends Node

func boolToSign(to_transform: bool) -> int:
	return 1 - 2 * int(to_transform)
