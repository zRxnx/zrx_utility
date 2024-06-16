fx_version 'cerulean'
game 'gta5'
lua54 'yes'
use_experimental_fxv2_oal 'yes'

author 'zRxnx'
description 'Utility library for my resources'
version '2.3.1'

docs 'https://docs.zrxnx.at'
discord 'https://discord.gg/mcN25FJ33K'

shared_scripts {
    'configuration/config.lua',
    'shared/*.lua',
}

client_scripts {
    'client/*.lua',
    'client/keymapping/*.lua',
    'client/menu/*.lua',
    'client/bridge/*.lua',
}

server_scripts {
    'configuration/webhook.lua',
    'server/*.lua',
    'server/log/*.lua',
    'server/version/*.lua',
    'server/bridge/*.lua',
}