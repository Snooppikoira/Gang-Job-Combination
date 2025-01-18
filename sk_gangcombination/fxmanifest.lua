fx_version 'cerulean'
games { 'gta5' }
lua54 'yes'

author "Snooppikoira"
version '1.0.0'

shared_scripts {'@ox_lib/init.lua', 'config.lua'}
client_scripts {'client/*.lua'}
server_scripts {'server/*.lua', '@oxmysql/lib/MySQL.lua',}