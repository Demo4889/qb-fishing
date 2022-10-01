fx_version 'cerulean'
game 'gta5'

shared_scripts {
  'config.lua'
}
client_scripts {
  '@PolyZone/client.lua',
	'@PolyZone/BoxZone.lua',
	'@PolyZone/ComboZone.lua',
  'client.lua'
}
server_scripts {
  '@oxmysql/lib/MySQL.lua',
	'server.lua'
}