# RideableAPI - Туториал: Создание ездового транспорта

Этот туториал проведёт вас через создание простого ездового транспорта
с использованием RideableAPI. В результате у вас будет рабочая сущность,
на которую игроки смогут садиться и с которой смогут слезать.

---

## Требования

- Базовое знание структуры контент-паков [VoxelCore](
  https://github.com/MihailRis/voxelcore)
- Понимание JSON и Lua
- [RideableAPI](https://github.com/Neveix/voxelcore-rideable-api)
  установлен в вашей папке `content/`

---

## Шаг 1: Создаём минимальный контент-пак

Создайте новую папку `rideable_tutorial` для вашего контент-пака
в папке `content/` и добавьте файл `package.json`.

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

## Шаг 2: Создаём определение сущности

Создайте `entities/vehicle.json`:

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

Создайте `skeletons/vehicle.json`:

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

Создайте `models/vehicle.obj`:

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

## Шаг 3: Создаём скриптовый компонент

Создайте `scripts/components/vehicle.lua`:

```lua
local rideable_api = require("rideable_api:mount")

console.chat("vehicle spawned")

function on_used()
	console.chat("vehicle used")
end
```

## Шаг 4: Проверка в игре

Давайте проверим, что всё работает, прежде чем добавлять новые возможности.

1. Запустите VoxelCore с загруженным контент-паком.
2. Откройте консоль, нажав клавишу "`" (обратный апостроф).
3. Введите `entity.spawn rideable_tutorial:vehicle ~ ~ ~`

Должна появиться невидимая сущность в виде куба 1x1x1 (модели пока нет,
но она существует).

Проверьте сообщения в чате:
- `"vehicle spawned"` — должно появиться при спавне
- `"vehicle used"` — должно появиться при клике правой кнопкой по сущности

Если вы видите оба сообщения, ваш контент-пак работает!

**Далее:** Мы реализуем логику посадки, чтобы игроки могли управлять
транспортом.

## Шаг 5: Реализация посадки игрока

Теперь добавим логику, чтобы игрок садился на транспорт при взаимодействии.

Сейчас `on_used` только выводит сообщение. Нам нужно:

1. **Посадить игрока** — вызвать `rideable_api.mount()`, чтобы зарегистрировать
   игрока как седока
2. **Двигать седока** — использовать `on_render()`, чтобы размещать игрока
   над транспортом каждый кадр
3. **Безопасно высаживать** — очищать состояние седока при уничтожении
   транспорта

Разберём новые части:

- **`entity.transform`** — используется для получения текущей позиции транспорта
  в мире
- **`rider_id`** — хранит ID игрока-седока (или `nil`, если никого нет)
- **`player_mount(pid)`** — вызывает `rideable_api.mount()` и сохраняет ID
  седока в случае успеха
- **`player_unmount()`** — перемещает игрока на 0.5 блоков выше транспорта
  и очищает `rider_id`
- **`on_despawn()`** — гарантирует, что седок будет высажен, если транспорт
  уничтожен
- **`on_render()`** — выполняется каждый кадр; если кто-то сидит, обновляет
  позицию игрока, чтобы он оставался над транспортом

Теперь замените весь `vehicle.lua` на этот код:

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
	if rider_id then
		rideable_api.unmount(rider_id)
	end
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

**Проверьте снова:** заспавньте транспорт и кликните по нему правой кнопкой.
Вы должны увидеть, как игрок телепортируется над транспортом и остаётся там.
Кликните правой кнопкой снова, чтобы высадиться и вернуться на землю.

## Следующие шаги

Теперь, когда у вас есть работающий транспорт, вы можете добавить:

- Пользовательские модели и текстуры
- Звуковые эффекты при посадке/высадке
- Управление скоростью и поворотами
- Поддержку нескольких мест
- Доступ к инвентарю (приседание + взаимодействие)

Теперь, когда вы понимаете основы, вы можете изучить полную документацию API:

- **[API Reference](./api.md)**
