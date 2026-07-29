# RideableAPI - Developer Documentation

**Engine version:** VoxelCore 0.31.4
This document describes how to use RideableAPI in your content pack.

---

## Overview

RideableAPI provides a simple registry for mounting and unmounting players on entities or seats. It does not handle physics, camera controls, or movement - these are the responsibility of the content pack that uses this API.

If you are new to content pack development or prefer a step-by-step guide, 
see the [Tutorial](./tutorial.md) first.

---

## Setup

To use RideableAPI in your content pack:

1. Copy the `typings/local/mount.lua` file to your project (for type annotations).
2. Require the API in your code:

```lua
---@type rideable_api
local rideable_api = require("rideable_api:api/v1/mount")
```


## API Reference

### `rideable_api.mount(pid, entity_uid, seat_id, on_unmount)`

Mounts a player on an entity or seat.

- If the player is already mounted, they are unmounted first.
- Triggers the `rideable_api:on_mount` event.

**Parameters:**

| Name | Type | Description |
| :--- | :--- | :--- |
| `pid` | `integer` | Player ID |
| `entity_uid` | `integer or nil` | Entity UID (optional, for reference) |
| `seat_id` | `any or nil` | Seat identifier (optional, for multi-seat support) |
| `on_unmount` | `function or nil` | Callback called on unmount: `fun(pid, entity_uid, seat_id)` |

**Returns:** `boolean` - `true` on success, `false` otherwise.

---

### `rideable_api.unmount(pid)`

Unmounts a player.

- Calls the stored `on_unmount` callback (if provided during mount).
- Triggers the `rideable_api:on_unmount` event.

**Parameters:**

| Name | Type | Description |
| :--- | :--- | :--- |
| `pid` | `integer` | Player ID |

**Returns:** `boolean` - `true` if the player was mounted and unmounted, `false` otherwise.

---

### `rideable_api.is_mounted(pid)`

Checks if a player is currently mounted.

**Parameters:**

| Name | Type | Description |
| :--- | :--- | :--- |
| `pid` | `integer` | Player ID |

**Returns:** `boolean`

---

### `rideable_api.get_mount_data(pid)`

Returns the mount data for a player.

**Parameters:**

| Name | Type | Description |
| :--- | :--- | :--- |
| `pid` | `integer` | Player ID |

**Returns:** `table|nil` - A table with `entity_uid` and `seat_id`, or `nil` if not mounted.

---

### `rideable_api.get_mount_entity(pid)`

Returns the entity UID that a player is mounted on (if any).

**Parameters:**

| Name | Type | Description |
| :--- | :--- | :--- |
| `pid` | `integer` | Player ID |

**Returns:** `integer|nil` - Entity UID or `nil` if not mounted or mounted on a non-entity.

---

## Events

The API emits the following events via the `events` library:

| Event | Payload | Description |
| :--- | :--- | :--- |
| `rideable_api:on_mount` | `pid, entity_uid, seat_id` | Fired after a player is mounted |
| `rideable_api:on_unmount` | `pid, entity_uid, seat_id` | Fired after a player is unmounted |

**Example:**

```lua
events.on("rideable_api:on_mount", function(pid, entity_uid, seat_id)
    console.chat("Player " .. pid .. " mounted on " .. entity_uid)
end)
```
