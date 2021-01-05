ESX = nil

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if ESX == nil then
            TriggerEvent('esx:GetObject', function(obj) ESX = obj end)
            Citizen.Wait(200)
        end
    end
end)

local searched = {3423423424}
local canSearch = true
local Car = Config.Searchable
local searchTime = Config.SearchTime

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function(time)
    while true do
        Citizen.Wait(0)
        if canSearch then
            local ped = GetPlayerPed(-1)
            local pos = GetEntityCoords(ped)
            local carFound = false

            for i = 1, #Car do
                local car = GetClosestObjectOfType(pos.x, pos.y, pos.z, 1.0, Car[i], false, false, false)
                local dumpPos = GetEntityCoords(car)
                local dist = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, dumpPos.x, dumpPos.y, dumpPos.z, true)
                local playerPed = PlayerPedId()


                if dist < 1.8 then
                    DrawText3Ds(dumpPos.x, dumpPos.y, dumpPos.z + 1.0, '[~g~E~w~] Basarak Aracı Ara!')
                    if IsControlJustReleased(0, 54) then
                        for i = 1, #searched do
                            if searched[i] == car then
                                carFound = true
                            end
                            if i == #searched and carFound then
                                exports['mythic_notify']:SendAlert('success', 'Bu Araç Zaten Arandı')
                            elseif i == #searched and not carFound then
                                exports['mythic_notify']:SendAlert('success', 'Arabayı Aramaya başladın!!')
                                exports['progressBars']:startUI(Config.SearchTime, "Aracı Arıyorsun.")
                                   startSearching(searchTime, 'amb@prop_human_bum_bin@base', 'base', 'z12:server:rewarditem')
                                   TriggerServerEvent('z12:startcarTimer', car)
                                table.insert(searched, car)
                                Citizen.Wait(1000)
                            end
                        end
                    end
                end
            end
        end
    end
end)

RegisterNetEvent('z12:removecar')
AddEventHandler('z12:removecar', function(object)
    for i = 1, #searched do
        if searched[i] == object then
            table.remove(searched, i)
        end
    end
end)

-- Fonksiyonlar (Elleme Don't Touch)

function startSearching(time, dict, anim, cb)
    local animDict = dict
    local animation = anim
    local ped = GetPlayerPed(-1)
    local playerPed = PlayerPedId()


    canSearch = false

    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(0)
    end
        TaskPlayAnim(ped, animDict, animation, 8.0, 8.0, time, 1, 1, 0, 0, 0)
    FreezeEntityPosition(playerPed, true)

    local ped = GetPlayerPed(-1)

    Wait(time)
    ClearPedTasks(ped)
    FreezeEntityPosition(playerPed, false)
    canSearch = true
    TriggerServerEvent(cb)
end

function DrawText3Ds(x, y, z, text)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local factor = #text / 460
	local px,py,pz=table.unpack(GetGameplayCamCoords())
	
	SetTextScale(0.3, 0.3)
	SetTextFont(6)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 160)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	DrawRect(_x,_y + 0.0115, 0.02 + factor, 0.027, 28, 28, 28, 95)
end