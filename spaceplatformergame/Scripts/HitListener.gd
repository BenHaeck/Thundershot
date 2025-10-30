extends Node

class_name HitListener

signal hit(body: Node2D)


enum DamageType {
	Generic = 0,
	Electric = 1,
	Stab = 1<<1,
	Burn = 1<<2,
}
