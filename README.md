# RideableAPI

A content pack for [VoxelCore](https://github.com/MihailRis/voxelcore)

[Русская версия](./docs/ru/README.md)

A lightweight, event-driven API for mounting and unmounting players on entities or seats.  
Designed for single-player content packs, with planned multiplayer support.

*Note: README was written with the assistance of AI.*

---

## Features

- Simple registry for player mounts
- Callback-based unmounting (each mount defines its own unmount logic)
- Event system integration (`rideable_api:on_mount`, `rideable_api:on_unmount`)

---

## Installation

1. Download the content pack.
2. Place the folder in your `content/` directory.

First and foremost, this solves the problem when there are boats, chairs, vehicles from different mods 
with different mounting systems — without a unified registry of "seated" players, a smooth transition 
from a boat to a vehicle or chair is impossible.

---

## For Players

This pack adds no visible items or mechanics on its own. 
It is a **library** that other content packs use to allow players to sit on or ride entities (boats, horses, chairs, etc.).

---

## For Developers

If you are a content pack developer and want to use this API in your project, please refer to the full documentation:

- [🇺🇸 API Documentation](./docs/en/api.md)
- [🇷🇺 Документация API](./docs/ru/api.md)

New to content pack development? Check out the step-by-step tutorial:
- [🇺🇸 Tutorial](./docs/en/tutorial.md)
- [🇷🇺 Туториал](./docs/ru/tutorial.md)

## Contributing

Bug reports, suggestions, and pull requests are welcome!  
Please use the [issue tracker](https://github.com/Neveix/voxelcore-rideable-api/issues) for feedback.

---

## License

MIT © Neveix
