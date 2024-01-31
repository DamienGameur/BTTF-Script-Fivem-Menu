local convecteurActive = false
local commandExecuted = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if IsControlJustPressed(1, 166) then
            menu()
        end
    end
end)
function menu()
    local menuTest = RageUI.CreateMenu("Retour Vers Le Futur", "Sous-titre")

    RageUI.Visible(menuTest, not RageUI.Visible(menuTest))

    while menuTest do
        Citizen.Wait(0)

        RageUI.IsVisible(menuTest, true, true, true, function()
            RageUI.ButtonWithStyle("Activer Convecteur Temporel", "Description", {RightLabel = convecteurActive and "On" or "Off"}, true, function(Hovered, Active, Selected)
                if Selected then
                    local playerPed = GetPlayerPed(-1)
                    local vehicle = GetVehiclePedIsIn(playerPed, false)

                    if IsVehicleModel(vehicle, GetHashKey("dmc12")) then
                        convecteurActive = not convecteurActive
                        PlayConvecteurSound()
                        
                        if convecteurActive then
                            Citizen.Wait(1000)
                            PlaybeepSound()
                            commandExecuted = false  -- Réinitialiser la variable
                            Citizen.CreateThread(function()
                                while convecteurActive do
                                    Citizen.Wait(0)
                                    
                                    local speed = GetEntitySpeed(playerPed) * 2.23694  -- Convertir la vitesse de m/s à mph
                            
                                    if speed > 88 and not commandExecuted then
                                        Playsparks_fuelSound()
                                        TriggerEvent("chatMessage", "Système", {255, 0, 0}, "Vitesse supérieure à 88 mph !")
                                        ExecuteCommand("start fut2")
                                        ExecuteCommand("start fut")                                      
                                        commandExecuted = true
                                        ExecuteCommand("tpm")
                                    elseif speed <= 88 and commandExecuted then
                                        TriggerEvent("chatMessage", "Système", {0, 255, 0}, "Vitesse redevenue inférieure à 88 mph. Arrêt de la commande 'fut'.")
                                        ExecuteCommand("stop fut2")
                                        ExecuteCommand("stop fut")
                                        commandExecuted = false
                                    end
                                end
                            end)
                        end
                    else
                        TriggerEvent("chatMessage", "Système", {255, 0, 0}, "Vous devez être dans une Deluxo pour activer le convecteur temporel.")
                    end
                end
            end)
            -- Rest of your menu code
        end)

        if not RageUI.Visible(menuTest) then
            menuTest = RMenu:DeleteType("Retour Vers Le Futur", true)
        end
    end
end

function PlayConvecteurSound()
    SendNUIMessage({sound = "Convecteur", volume = 1.0})
end

function PlaybeepSound()
    SendNUIMessage({sound = "beep", volume = 1.0})
end

function Playsparks_fuelSound()
    SendNUIMessage({sound = "sparks_fuel", volume = 1.0})
end