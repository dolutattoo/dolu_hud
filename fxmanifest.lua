fx_version 'cerulean'
use_experimental_fxv2_oal 'yes'
lua54 'yes'
game 'gta5'

name 'dolu_hud'
version '0.0.1'
description 'HUD for overextended framework'
author 'Dolu'
repository 'https://github.com/dolutattoo/dolu_hud'

shared_scripts {
	'@ox_lib/init.lua',
	'shared/init.lua',
	'shared/utils.lua',
	'config.lua'
}

client_scripts {
	'@ox_core/imports/client.lua',
	'client/**/*.lua',
}

server_scripts {
	'@ox_core/imports/server.lua',
	'server/**/*.lua',
}

ui_page 'web/build/index.html'

files {
	'web/build/index.html',
	'web/build/**/*',
	'shared/img/**/*.webp',
	'locales/*.json'
}

dependencies {
	'/onesync',
	'pma-voice',
	'ox_lib',
	'ox_core'
}