-- Module to manage undo/redo history for terrain modifications
local HistoryManager = {}

local undoStack = {}
local redoStack = {}
local MAX_HISTORY = 50

--[[
    Records a new action to the history. This should be called *before* the action is performed.
    @param targetTerrain The terrain object being modified.
    @param region The Region3 that will be affected.
--]]
function HistoryManager.recordAction(targetTerrain, region)
	if not targetTerrain or not region then return end

	-- Clear the redo stack whenever a new action is performed
	redoStack = {}

	-- Read the "before" state of the voxels
	local materials, occupancies = targetTerrain:ReadVoxels(region, 4)

	table.insert(undoStack, {
		terrain = targetTerrain,
		region = region,
		materials = materials,
		occupancies = occupancies
	})

	-- Limit the size of the history
	if #undoStack > MAX_HISTORY then
		table.remove(undoStack, 1)
	end
end

--[[
    Performs an undo operation.
--]]
function HistoryManager.undo()
	if #undoStack == 0 then
		print("Nothing to undo.")
		return
	end

	local lastAction = table.remove(undoStack)

	-- Read the "after" state to store in the redo stack
	local currentMaterials, currentOccupancies = lastAction.terrain:ReadVoxels(lastAction.region, 4)
	table.insert(redoStack, {
		terrain = lastAction.terrain,
		region = lastAction.region,
		materials = currentMaterials,
		occupancies = currentOccupancies
	})

	-- Restore the "before" state
	lastAction.terrain:WriteVoxels(lastAction.region, 4, lastAction.materials, lastAction.occupancies)
	print("Undo successful.")
end

--[[
    Performs a redo operation.
--]]
function HistoryManager.redo()
	if #redoStack == 0 then
		print("Nothing to redo.")
		return
	end

	local nextAction = table.remove(redoStack)

	-- Read the "before" state to put back in the undo stack
	local currentMaterials, currentOccupancies = nextAction.terrain:ReadVoxels(nextAction.region, 4)
	table.insert(undoStack, {
		terrain = nextAction.terrain,
		region = nextAction.region,
		materials = currentMaterials,
		occupancies = currentOccupancies
	})

	-- Restore the "after" state
	nextAction.terrain:WriteVoxels(nextAction.region, 4, nextAction.materials, nextAction.occupancies)
	print("Redo successful.")
end

return HistoryManager
