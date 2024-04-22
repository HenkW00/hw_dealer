fx_version 'adamant'
games { 'gta5' }

author 'HenkW'
description 'Simple dealer script that allows players to sell illegal items'
version '1.0.2'

client_scripts {
    'client/main.lua',
}

server_scripts {
    'server/main.lua',
    'server/version.lua',
}

shared_scripts {
    'config.lua',
}

shared_script '@es_extended/imports.lua'
