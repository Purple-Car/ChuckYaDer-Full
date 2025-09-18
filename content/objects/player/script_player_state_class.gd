extends Node

class_name State

@export var can_move: bool = true

var player: CharacterBody2D
var next_state: State

func stateProcess(delta): pass

func stateInput(event: InputEvent): pass

func onEnter(): pass

func onExit(): pass

func onAnimationFinished(finished_animation: String): pass

func onGrabDetectSomething(body: Node2D): pass
