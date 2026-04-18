extends Resource

class_name BoardData

enum CellType{
	EMPTY,
	SNAKE,
	FRUIT,
	WALL,
	OUT_OF_BOUNDS,
	
}

const EMPTY = CellType.EMPTY
const WALL = CellType.WALL
const FRUIT = CellType.FRUIT
const OUT_OF_BOUNDS = CellType.OUT_OF_BOUNDS
const SNAKE = CellType.SNAKE

@export var board : Dictionary[Vector2i, CellType]
