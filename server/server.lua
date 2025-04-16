local VorpCore
local VorpInv
TriggerEvent("getCore",function(core)
    VorpCore = core
end)

VorpInv = exports.vorp_inventory:vorp_inventoryApi()

VorpInv.RegisterUsableItem(Config.MapItem, function(data)
    local _source = data.source
    if _source then
        TriggerClientEvent("AWZ_vlab_horsemap:checkIfOnFoot", _source)
        VorpInv.CloseInv(_source)
    end
end)