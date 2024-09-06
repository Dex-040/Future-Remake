fx_version 'adamant'
game 'gta5'



description 'NewLife Script voor ESX'

games { 'gta5'}
use_fxv2_oal 'yes'
lua54 'yes'
author 'Dex040'
dependencies {
    'es_extended',
    'oxmysql',
    'ox_lib'
}
shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
}
client_scripts {
    'config/config.lua',
    'client/client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'config/config.lua',
    'server/server.lua'
}

escrow_ignore {
    'config.lua'
}
dependency '/assetpacks'
