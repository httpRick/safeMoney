local triggerEventName = "onClientPlayerCheckMoney"

local playersMoney = {}
local playersUpdate = {}
local functionTimer = false

function handlerFunctionTimer(func)
    local players = getElementsByType("player")
    local result = tableIsEmpty(players)
    if not result then
        if not functionTimer then
            functionTimer = setTimer(func, 5000, 0)
            return true
        end
    elseif result then
        if functionTimer then
            killTimer(functionTimer)
            functionTimer = nil
            return true
        end
    end
    return false
end

function tableIsEmpty(pTable)
    for key, value in pairs(pTable) do
        if key then
            return false
        end
    end
    return true
end

function handlePlayerMoneyCheck()
    local playersTable = getElementsByType("player")
    if not tableIsEmpty(playersTable) then
        playersUpdate = {}
        for playerID = 1, #playersTable do
            local playerElement = playersTable[playerID]
            local savedMoney = playersMoney[playerElement]
            local currentMoney = getPlayerMoney(playerElement)
            if savedMoney ~= currentMoney then
                playersUpdate[playerElement] = currentMoney
                playersMoney[playerElement] = getPlayerMoney(playerElement)
            end
        end
        if not triggerClientEvent(playersTable, triggerEventName, resourceRoot, playersUpdate) then
            for playerID = 1, #playersTable do
                local playerElement = playersTable[playerID]
                if isElement(playerElement) then
                    if not triggerClientEvent(playerElement, triggerEventName, resourceRoot, playersUpdate) then
                        kickPlayer(playerElement, "Suspicious activity detected")
                        outputChatBox("*[KICK] "..getPlayerName(playerElement).." suspicious activity detected by the player.", root, 255, 0, 0)
                    end
                end
            end
        end
    end
end

function onResourceStartServer()
    handlerFunctionTimer(handlePlayerMoneyCheck)
end
addEventHandler("onResourceStart", resourceRoot, onResourceStartServer) 

function onPlayerJoinServer() 
    handlerFunctionTimer(handlePlayerMoneyCheck)
end
addEventHandler("onPlayerJoin", root, onPlayerJoinServer)

function onPlayerQuitServer() 
    handlerFunctionTimer()
end
addEventHandler("onPlayerQuit", root, onPlayerQuitServer)
