extends Node3D

@onready var area = $Area3D

func _ready():
	area.connect("body_entered", _on_body_entered)
	area.connect("body_exited", _on_body_exited)

func _on_body_entered(body):
	print("🐾 El jugador se acerca... la criatura te observa con curiosidad.")

func _on_body_exited(body):
	print("🐾 El jugador se aleja... la criatura vuelve a relajarse.")
