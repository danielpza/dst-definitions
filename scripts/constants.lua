---@meta

PI = 3.14159
PI2 = PI * 2
DEGREES = PI / 180
RADIANS = 180 / PI
FRAMES = 1 / 30
TILE_SCALE = 4

---@enum ds.equipslot
EQUIPSLOTS = {
   HANDS = "hands",
   HEAD = "head",
   BODY = "body",
   BEARD = "beard",
}

---@alias ds.hanchor `ANCHOR_MIDDLE` | `ANCHOR_LEFT` | `ANCHOR_RIGHT`
---@alias ds.vanchor `ANCHOR_MIDDLE` | `ANCHOR_TOP` | `ANCHOR_BOTTOM`
ANCHOR_MIDDLE = 0
ANCHOR_LEFT = 1
ANCHOR_RIGHT = 2
ANCHOR_TOP = 1
ANCHOR_BOTTOM = 2
