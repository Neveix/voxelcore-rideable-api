# RideableAPI - Tutorial: Creating a Rideable Vehicle

This tutorial walks you through creating a simple rideable vehicle using RideableAPI. By the end, you will have a working vehicle entity that players can mount and unmount.

---

## Prerequisites

- Basic knowledge of [VoxelCore](https://github.com/MihailRis/voxelcore) content pack structure
- Understanding of JSON, Lua
- [RideableAPI](https://github.com/Neveix/voxelcore-rideable-api) installed in your `content/` folder

---

## Step 1: Create a Minimal Content Pack

Create a new folder `rideable_tutorial` for your content pack in `content/` folder and add a `package.json` file.

```json
{
  "id": "rideable_tutorial",
  "title": "Rideable tutorial",
  "version": "1.0.0",
  "creator": "",
  "description": "",
  "dependencies": [
    "rideable_api"
  ]
}
```

## Step 2: Create the Entity Definition

Create `entities/vehicle.json`:

```json
{
  "components": [
    "rideable_tutorial:vehicle"
  ],
  "body-type": "dynamic",
  "hitbox": [
    1,
    1,
    1
  ]
}
```

Create `skeletons/vehicle.json`
```json
{
  "root": {
    "nodes": [
      {
        "name": "vehicle",
        "model": "vehicle"
      }
    ]
  }
}
```

Create `models/vehicle.obj`
```obj
# Cube 1x1x1
v -0.5 -0.5 -0.5
v  0.5 -0.5 -0.5
v  0.5  0.5 -0.5
v -0.5  0.5 -0.5
v -0.5 -0.5  0.5
v  0.5 -0.5  0.5
v  0.5  0.5  0.5
v -0.5  0.5  0.5

f 5 6 7 8
f 1 4 3 2
f 4 8 7 3
f 1 2 6 5
f 2 3 7 6
f 1 5 8 4
```

## Step 3: Create the Script Component

Create `scripts/components/vehicle.lua`:
```lua
local rideable_api = require("rideable_api:mount")

console.chat("vehicle spawned")

function on_used()
	console.chat("vehicle used")
end
```

## Step 4: Test in Game

Let's verify everything works before adding more features.

1. Launch VoxelCore with your content pack loaded.
2. Open the console by pressing the "`" key.
3. Type `entity.spawn rideable_tutorial:vehicle ~ ~ ~`

This should spawn an invisible 1x1x1 cube entity (it has no model yet, but it exists).

Check the chat for messages:
- `"vehicle spawned"` — should appear on spawn
- `"vehicle used"` — should appear when you right-click the entity

If you see both messages, your content pack is working!

**Next:** We will implement the actual mounting logic so players can ride the vehicle.

## Step 5: Implement Player Mounting

Now we add the logic to mount a player when they interact with the vehicle.

At the moment, `on_used` just prints a message. We need to:

1. **Mount the player** — call `rideable_api.mount()` to register the player as a rider
2. **Move the rider** — use `on_render()` to place the player above the vehicle every frame
3. **Unmount safely** — clean up the rider state when the vehicle is destroyed

Let's go through the new parts:

- **`entity.transform`** — used to get the vehicle's current world position
- **`rider_id`** — stores the player ID of the rider (or `nil` if empty)
- **`player_mount(pid)`** — calls `rideable_api.mount()` and stores the rider ID on success
- **`player_unmount()`** — moves the player 0.5 blocks above the vehicle and clears `rider_id`
- **`on_despawn()`** — ensures the rider is unmounted if the vehicle is destroyed
- **`on_render()`** — runs every frame; if someone is riding, it updates the player's position to stay above the vehicle

Now replace the entire `vehicle.lua` with this:
```lua
local rideable_api = require("rideable_api:mount")

local tsf = entity.transform

local rider_id = nil

local function player_unmount()
	if rider_id then
		local x, y, z = player.get_pos(rider_id)
		player.set_pos(rider_id, x, y + 0.5, z)
		rider_id = nil
	end
end

function on_despawn()
	player_unmount()
end

local function player_mount(pid)
	rideable_api.unmount(pid)
	local success = rideable_api.mount(pid, entity:get_uid(), nil, player_unmount)
	if success then
		rider_id = pid
	end
end

function on_used(pid)
	if rider_id == pid then
		player_unmount()
		return
	end
	player_mount(pid)
end

function on_render(_)
	if rider_id == nil then
		return
	end
	local pos = tsf:get_pos()
	player.set_vel(rider_id, 0, 0, 0)
	player.set_pos(rider_id, pos[1], pos[2] + 1, pos[3])
end
```

**Test it again:** spawn the vehicle and right-click it. 
You should see your player teleport above the vehicle and will be pinned there.
Right-click again to unmount and drop back to the ground.

## Next Steps

Now that you understand the basics, you can explore the complete API reference:

- **[API Reference](./api.md)**
