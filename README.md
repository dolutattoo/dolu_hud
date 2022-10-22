# dolu_hud (Work in progress)

This is a FiveM resource who provides status system with hud elements.
Only work for Overextended framework, not ESX or anything else.
The nui was made using React and Mantine UI.
<div align='center' style='width:25vw'><img src='https://i.imgur.com/depQRs9.png'/></div>

## Dependencies
- [ox_lib](https://github.com/overextended/ox_lib/releases/latest)
- [ox_core](https://github.com/overextended/ox_core/releases/latest)
- [ox_inventory](https://github.com/overextended/ox_inventory/releases/latest)

## Features
- Show minimap in vehicle only
- Support using food/drink items from ox_inventory
- Status add/remove system depending on config
- Saving status as character metadata in database
- '/heal' command
- Hud elements:
	- `Health`<br>
		Simply show the current health

	- `Armour`<br>
		Show the current armour, just use the armour item!

	- `Hunger`<br>
		Start from 100 and decrease slowly to 0.<br>
		When 0, decrease health slowly. (todo)

	- `Thirst`<br>
		Start from 100 and decrease slowly to 0.<br>
		When 0, decrease health slowly. (todo)

	- `Stress`<br>
		Start from 0 and increase slowly to 100.<br>
		When 100, decrease health slowly. (todo)

	- `Drunk`<br>
		Start from 0 and increase slowly to 100.<br>
		When 100, decrease health slowly. (todo)

	- `Oxygen` (underwater)<br>
		Same comportment as vanilla, which is fine

## Notes
Any ped used by player will have max health set to 200 (by default, `mp_f_freemode_01` and some other peds has 150, while `mp_m_freemode_01` has 200).

## How to install
You need to add this function to `ox_inventory/modules/bridge/ox/client.lua`:
```lua
function client.setPlayerStatus(values)
	for name, value in pairs(values) do
		TriggerEvent('ox:status:update', name, value)
	end
end
```

This resource is still under development, but you can test it by building the `web` folder using `pnpm`:
```
cd ./web
pnpm i
pnpm build
```