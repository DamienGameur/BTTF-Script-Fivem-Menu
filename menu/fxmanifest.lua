fx_version 'bodacious'
game 'gta5'

author '@interglot1' -- Twitter
description 'Magic Stuff'
version '1.0.0'

ui_page "ui/index.html"

files {
	"ui/index.html",
	"ui/sounds/*.ogg",
    "ui/sounds/*.png",
}

client_scripts {'client/*.lua'}





client_scripts {'cl_main.lua'}

server_scripts {'server.lua'}

shared_scripts {'config.lua'}



client_scripts {
    "src/RMenu.lua",
    "src/menu/RageUI.lua",
    "src/menu/Menu.lua",
    "src/menu/MenuController.lua",
    "src/components/*.lua",
    "src/menu/elements/*.lua",
    "src/menu/items/*.lua",
    "src/menu/panels/*.lua",
    "src/menu/panels/*.lua",
    "src/menu/windows/*.lua"
}


files {
    'data/**/*.meta'
}

data_file 'HANDLING_FILE'            'data/**/handling*.meta'
data_file 'VEHICLE_LAYOUTS_FILE'    'data/**/vehiclelayouts*.meta'
data_file 'VEHICLE_METADATA_FILE'    'data/**/vehicles*.meta'
data_file 'CARCOLS_FILE'            'data/**/carcols*.meta'
data_file 'VEHICLE_VARIATION_FILE'    'data/**/carvariations*.meta'
data_file 'CONTENT_UNLOCKING_META_FILE' 'data/**/*unlocks.meta'
data_file 'PTFXASSETINFO_FILE' 'data/**/ptfxassetinfo.meta'





