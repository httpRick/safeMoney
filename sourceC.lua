local money = false
local tick = getTickCount()

function onClientPreRenderMoney()
    if getTickCount()-tick > 500 then
        if tonumber(money) and getPlayerMoney(localPlayer) ~= money then
            setPlayerMoney(money, true)
        end
        tick = getTickCount()
    end
end
addEventHandler("onClientPreRender", root, onClientPreRenderMoney)

function onClientPlayerCheckMoney(pMoneyData)
    if source == resourceRoot then
        if pMoneyData and pMoneyData[localPlayer] then
            if pMoneyData[localPlayer] ~= getPlayerMoney(localPlayer) then
                setPlayerMoney(pMoneyData[localPlayer])
                money = tonumber(pMoneyData[localPlayer])
            end
        end
    end
end
addEvent("onClientPlayerCheckMoney", true)
addEventHandler("onClientPlayerCheckMoney", root, onClientPlayerCheckMoney)
