--[[ FX Information ]] --
fx_version 'cerulean'
use_experimental_fxv2_oal 'yes'
lua54 'yes'
game 'gta5'

--[[ Resource Information ]] --
name 'dolu_hud'
version      '1.1.0'
description 'HUD for overextended framework'
author 'Dolu'
repository 'https://github.com/dolutattoo/dolu_hud'

--[[ Manifest ]] --
dependencies {
	'/onesync',
	'pma-voice',
	'ox_lib'
}

shared_scripts {
	'@ox_lib/init.lua',
	'shared/init.lua',
	'shared/utils.lua'
}

client_scripts {
	'@ox_core/imports/client.lua',
	'client/*.lua'
}

server_scripts {
	'@ox_core/imports/server.lua',
	'server/*.lua'
}

ui_page 'web/build/index.html'

files {
	'config.json',
	'web/build/index.html',
	'web/build/**/*'
}
