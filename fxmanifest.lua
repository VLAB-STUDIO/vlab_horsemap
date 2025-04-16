fx_version 'cerulean'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

author '𝐕𝐋𝐀𝐁 𝐒𝐭𝐮𝐝𝐢𝐨 @𝗔͟𝘅𝗲̅𝗲̅𝗹𝗪͟𝗭'

client_scripts {
    'client/*.lua'
}

server_scripts {
    'server/*.lua'
}

shared_script 'shared/*.lua'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/styles.css',
    'html/script.js',
    'html/imgs/*.png',
    'images/*.png'
}

dependency {
    'vorp_inventory',
    'vorp_menu'
}