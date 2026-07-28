---@type rideable_api
---@diagnostic disable-next-line
local M = {}

-- [pid] = { entity_uid, seat_id, unmount_callback }
local mounts = {}

function M.mount(pid, entity_uid, seat_id, on_unmount)
	if not pid then
		return false
	end

	if mounts[pid] then
		M.unmount(pid)
	end

	mounts[pid] = {
		entity_uid = entity_uid,
		seat_id = seat_id,
		unmount_callback = on_unmount or function() end,
	}

	events.emit("rideable_api:on_mount", pid, entity_uid, seat_id)
	return true
end

function M.unmount(pid)
	local data = mounts[pid]
	if not data then
		return false
	end

	data.unmount_callback(pid, data.entity_uid, data.seat_id)

	mounts[pid] = nil

	events.emit("rideable_api:on_unmount", pid, data.entity_uid, data.seat_id)
	return true
end

function M.is_mounted(pid)
	return mounts[pid] ~= nil
end

function M.get_mount_data(pid)
	return mounts[pid]
end

function M.get_mount_entity(pid)
	local data = mounts[pid]
	return data and data.entity_uid or nil
end

return M
