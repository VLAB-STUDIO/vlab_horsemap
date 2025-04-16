local Menu = exports.vorp_menu:GetMenuData()
local T = Translation.Langs[Config.Lang]

local currentImage = nil
local currentHorseBlip = nil
local currentGpsRoute = nil

function ShowImage(imageUrl)
    SendNUIMessage({
        type = "showImage",
        image = imageUrl
    })
    currentImage = imageUrl
end

function HideImage()
    SendNUIMessage({
        type = "hideImage"
    })
    currentImage = nil
end

local createdBlips = {}

local function addBlipsForHorse(horseData)
    for _, coords in ipairs(horseData.coords) do
        local blip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, coords.x, coords.y, coords.z)
        SetBlipSprite(blip, GetHashKey(Config.HashBlip), true)
        SetBlipScale(blip, 0.2)
        Citizen.InvokeNative(0x9CB1A1623062F402, blip, horseData.label)
        local radiusBlip = Citizen.InvokeNative(0x45f13b7e0a15c880, -1282792512, coords.x, coords.y, coords.z, 250.0)
        Citizen.InvokeNative(0x662D364ABF16DE2F, radiusBlip, GetHashKey(Config.HashBlip))
        table.insert(createdBlips, {radiusBlip = radiusBlip, mainBlip = blip})
        Citizen.InvokeNative(0xA4EA0691, blip, Config.TimeRemoveBlips / 1000) 
        Citizen.SetTimeout(Config.TimeRemoveBlips, function()
            RemoveBlip(blip)
            RemoveBlip(radiusBlip)
            TriggerEvent("vorp:NotifyLeft", "~e~"..T.TitleOpenMap, T.TextBlipRemoved, "pm_awards_mp", "awards_set_f_004", 5000, "COLOR_PURE_WHITE")
        end)
    end
end

function RemoveAllCreatedBlips()
    for _, blipEntry in ipairs(createdBlips) do
        if blipEntry.radiusBlip then
            RemoveBlip(blipEntry.radiusBlip)
        end
        if blipEntry.mainBlip then
            RemoveBlip(blipEntry.mainBlip)
        end
    end
    createdBlips = {}
end

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        RemoveAllCreatedBlips()
    end
end)

RegisterNetEvent("AWZ_vlab_horsemap:checkIfOnFoot")
AddEventHandler("AWZ_vlab_horsemap:checkIfOnFoot", function()
    local playerPed = PlayerPedId()
    if IsPedOnFoot(playerPed) then
        TriggerEvent("AWZ_vlab_horsemap:open")
    else
        TriggerEvent("vorp:TipBottom", T.TextCantUseWhileRiding, 5000)
    end
end)

RegisterNetEvent("AWZ_vlab_horsemap:open")
AddEventHandler("AWZ_vlab_horsemap:open", function()
    local menuOptions = {}
    local playerPed = PlayerPedId()
    TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WRITE_NOTEBOOK", 0, true)
    Citizen.Wait(4500)
    ExecuteCommand("hideui")
    TriggerEvent("vorp:NotifyLeft", "~e~"..T.TitleOpenMap, T.TextOpenMap, "pm_awards_mp", "awards_set_h_008", 5000, "COLOR_PURE_WHITE")
    for _, item in ipairs(Config.MenuItems) do
        local horseDesc = item.desc .. 
                    "<br>" ..
                    "<br><span style='font-family: Arial, sans-serif; font-size: 14px; color: #FF5733;'>" .. "<img style='max-height:3600px;max-width:200px;' src='nui://vlab_horsemap/images/divider_line.png'>" ..
                    "<br><strong>".. T.health .. ":</strong> " .. "<span style='font-family: Arial, sans-serif; font-size: 14px; color:rgb(252, 255, 51);'>" .. item.health .. " " .. "<img style='max-height:18px;max-width:18px; vertical-align: middle;' src='nui://vlab_horsemap/images/itemtype_horse_health.png'>" ..
                    "<br><span style='font-family: Arial, sans-serif; font-size: 14px; color: #FF5733;'>" .. "<img style='max-height:3600px;max-width:200px;' src='nui://vlab_horsemap/images/divider_line.png'>" ..
                    "<br><strong>" .. T.stamina .. ":</strong> " .. "<span style='font-family: Arial, sans-serif; font-size: 14px; color:rgb(252, 255, 51);'>" .. item.stamina .. " " .. "<img style='max-height:18px;max-width:18px; vertical-align: middle;' src='nui://vlab_horsemap/images/itemtype_horse_stamina.png'>" ..
                    "<br><span style='font-family: Arial, sans-serif; font-size: 14px; color: #FF5733;'>" .. "<img style='max-height:3600px;max-width:200px;' src='nui://vlab_horsemap/images/divider_line.png'>" ..
                    "<br><strong>" .. T.rarity .. ":</strong> " .. "<span style='font-family: Arial, sans-serif; font-size: 14px; color:rgb(252, 255, 51);'>" .. item.rarity .. " " .. "<img style='max-height:18px;max-width:18px; vertical-align: middle;' src='nui://vlab_horsemap/images/transaction_horse_bond.png'>" ..
                    "<br><span style='font-family: Arial, sans-serif; font-size: 14px; color: #FF5733;'>" .. "<img style='max-height:3600px;max-width:200px;' src='nui://vlab_horsemap/images/divider_line.png'>" ..
                    "<br><strong>" .. T.trainer .. ":</strong> " .. "<span style='font-family: Arial, sans-serif; font-size: 14px; color:rgb(252, 255, 51);'>" .. item.trainer .. " " .. "<img style='max-height:18px;max-width:18px; vertical-align: middle;' src='nui://vlab_horsemap/images/transaction_xp.png'>" ..
                    "<br><img style='max-height:3600px;max-width:200px;' src='nui://vlab_horsemap/images/divider_line.png'>"
        local horseLabel = "<div style='position: relative; display: inline-block; width: 100%; text-align: center;'>" ..
                   "<img style='position: absolute; left: 0; top: 50%; transform: translateY(-50%); max-height:18px; max-width:18px;' src='nui://vlab_horsemap/images/itemtype_horse.png'> " ..
                   item.label ..
                   "<img style='position: absolute; right: 0; top: 50%; transform: translateY(-50%); max-height:18px; max-width:18px;' src='nui://vlab_horsemap/images/itemtype_horse.png'>" ..
                   "</div>"
                   table.insert(menuOptions, {
                    label = horseLabel,
                    desc =  "<span style='font-family: Arial, sans-serif; font-size: 24px; color:rgb(255, 255, 255);'>" .. "<strong>" .. item.label .. "</span>" ..
                    "<br>" ..
                    "<span style='font-family: Arial, sans-serif; font-size: 15px; color:rgb(163, 163, 163); font-style: italic;'>" .. horseDesc .. "</span>" ..
                    "<br>" ..
                    "<br><img style='max-height:52px;max-width:52px;' src='nui://vlab_horsemap/images/" .. item.descimgs .. ".png'>",
                    value = _,
                })                
    end

    Menu.Open("default", GetCurrentResourceName(), "menu_principale", {
        title = T.title,
        subtext = "<div style='position: relative; display: inline-block; width: 100%; text-align: center;'>" ..
                   "<img style='position: absolute; left: 10; top: 50%; transform: translateY(-50%); max-height:24px; max-width:24px;' src='nui://vlab_horsemap/images/generic_horse_dx.png'> " ..
                    T.subtitle .. 
                    "<img style='position: absolute; right: 10; top: 50%; transform: translateY(-50%); max-height:24px; max-width:24px;' src='nui://vlab_horsemap/images/generic_horse_sx.png'>" ..
                   "</div>",
        "<br>",
        align = "top-right",
        elements = menuOptions,
        itemHeight = "2vh",
    },
    function(data, menu)
        if data.current and data.current.value then
            local horseData = Config.MenuItems[data.current.value]
            TriggerEvent("vorp:NotifyLeft", "~e~"..T.TitleOpenMap, T.TextSelectedHorse .. " ~e~" .. horseData.label .. "~q~ ", "pm_awards_mp", "awards_set_e_002", 6000, "COLOR_PURE_WHITE")
            ExecuteCommand("hideui")
            
            addBlipsForHorse(horseData)

            local playerPed = PlayerPedId()
            ClearPedTasks(playerPed)
            menu.close()
            HideImage()
        end
    end,
    function(data, menu)
        HideImage()
        local playerPed = PlayerPedId()
        ClearPedTasks(playerPed)
        menu.close()
        ExecuteCommand("hideui")
        HideImage()
    end,
    function(data, menu)
        if data.current and data.current.value then
            local fullScreenImage = Config.MenuItems[data.current.value].image
            ShowImage(fullScreenImage)
        else
            HideImage()
        end
    end)

    if Config.MenuItems[1] and Config.MenuItems[1].image then
        ShowImage(Config.MenuItems[1].image)
    end
end)