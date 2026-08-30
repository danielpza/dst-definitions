---@meta
-- DST Modding Environment & Engine Globals
--
-- Origins & Source of Truth:
--   - Engine Globals (TheInput, ThePlayer, TheWorld, TheSim, TheNet, TheFrontEnd, etc.):
--       Declared in `dst-scripts-original/scripts/main.lua` and initialized across game lifecycle
--       (e.g., `TheWorld` in `prefabs/world.lua`, `ThePlayer` in `gamelogic.lua`/`player_classified.lua`).
--   - Mod Environment API (GetModConfigData, AddComponentPostInit, AddClassPostConstruct, etc.):
--       Injected into the mod environment in `dst-scripts-original/scripts/mods.lua` and `modutil.lua`.
--   - Global Helpers & Scheduler (SpawnPrefab, StartThread, KillThread, Sleep, etc.):
--       Defined in `dst-scripts-original/scripts/mainfunctions.lua` and `scheduler.lua`.
--   - `GLOBAL` Table:
--       Injected as reference to Lua global table `_G` via `mods.lua` (line 328: `GLOBAL = _G`).
--
-- Where to reconcile issues:
--   - Inspect canonical implementations in `dst-scripts-original/scripts/`.
--   - For auto-generated script definitions (`definitions/scripts/`), update `gendefs.toml` or `tools/gendefs/` (DO NOT edit generated files manually).
--   - For global mod environment stubs / top-level engine definitions, edit this file (`definitions/dst.lua`).

---@type ds.input
TheInput = nil

---@type ds.prefabs.player_common?
ThePlayer = nil

---@type ds.prefabs.world?
TheWorld = nil

---@type any
TheSim = nil

---@type any
TheNet = nil

---@type any
TheFrontEnd = nil

---@param fn fun()
---@return any
function StartThread(fn) end

---@param thread any
function KillThread(thread) end

---@param time number
function Sleep(time) end

---@class GLOBAL
GLOBAL = {
   CHEATS_ENABLED = false,
   ACTIONS = ACTIONS,
   EQUIPSLOTS = EQUIPSLOTS,

   require = require,

   TheInput = TheInput,
   ThePlayer = ThePlayer,
   TheWorld = TheWorld,
   TheSim = TheSim,
   TheNet = TheNet,
   TheFrontEnd = TheFrontEnd,

   SpawnPrefab = SpawnPrefab,
   StartThread = StartThread,
   KillThread = KillThread,
   Sleep = Sleep,
}
