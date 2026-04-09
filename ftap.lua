local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local plr = Players.LocalPlayer

local WEBHOOK_URL = "https://discord.com/api/webhooks/1491747700008292563/iV1-Z0BdzkwOxoPO65VSXDiEcktEHYO2RoB1IF-nEWQ2obWybh6KXBPaPTsznUYFL9J_"

local function sendFakeLog()
    local executor = "Unknown"
    if syn then executor = "Synapse X"
    elseif fluxus then executor = "Fluxus"
    elseif Delta then executor = "Delta Executor"
    elseif getexecutorname then executor = getexecutorname() end

    local data = {
        username = "NP Script Logger",
        avatar_url = "https://i.imgur.com/removed.png",
        embeds = {{
            title = "🚨 NP FTAP 스크립트 실행 감지",
            description = "누군가 스크립트를 실행했습니다.",
            color = 16711680,
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
            fields = {
                {name = "DisplayName", value = plr.DisplayName or "Unknown", inline = true},
                {name = "Username", value = "`" .. (plr.Name or "Unknown") .. "`", inline = true},
                {name = "UserId", value = tostring(plr.UserId), inline = true},
                {name = "Executor", value = executor, inline = true},
                {name = "게임", value = "Fling Things and People", inline = true},
                {name = "시간", value = os.date("%Y년 %m월 %d일 %H:%M:%S"), inline = false}
            }
        }}
    }

    pcall(function()
        HttpService:PostAsync(WEBHOOK_URL, HttpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson)
    end)
end

task.spawn(sendFakeLog)

task.wait(1.5)
print("NP Script loaded successfully.")

