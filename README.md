# RideableAPI

A content pack for [VoxelCore](https://github.com/MihailRis/voxelcore)

A lightweight, event-driven API for mounting and unmounting players on entities or seats.  
Designed for single-player content packs, with planned multiplayer support.

---

## Features

- Simple registry for player mounts
- Callback-based unmounting (each mount defines its own unmount logic)
- Event system integration (`rideable_api:on_mount`, `rideable_api:on_unmount`)

---

## Installation

1. Download the content pack.
2. Place the folder in your `content/` directory.

---

## For Players

This pack adds no visible items or mechanics on its own. It is a **library** that other content packs use to allow players to sit on or ride entities (boats, horses, chairs, etc.).

If a content pack requires RideableAPI, it will tell you. Simply install it and forget about it - other packs will handle the rest.

---

## For Developers

If you are a content pack developer and want to use this API in your project, please refer to the full documentation:

- [🇺🇸English API Documentation](./docs/en/api.md)
- [🇷🇺Русская документация](./docs/ru/api.md)

New to content pack development? Check out the step-by-step tutorial:
- [English Tutorial](./docs/en/tutorial.md)
- [Русский туториал](./docs/ru/tutorial.md)

## Contributing

Bug reports, suggestions, and pull requests are welcome!  
Please use the [issue tracker](https://github.com/Neveix/voxelcore-rideable-api/issues) for feedback.

---

## License

MIT © Neveix
