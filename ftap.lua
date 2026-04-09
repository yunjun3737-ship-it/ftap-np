local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local plr = Players.LocalPlayer

-- 현재 가장 잘 되는 Proxy
local WEBHOOK_URL = "https://webhook.lewisakura.moe/1491747688415498393/wXHLss9QvcYHhFj60W-g6aLQ8lHkLkQ3yAzXJzI337MCFnQpQR5q9v31WGB9pBS4LGQQ"

local function sendLog()
    local executor = "Unknown"
    if syn then executor = "Synapse X"
    elseif fluxus then executor = "Fluxus"
    elseif Delta then executor = "Delta Executor"
    elseif getexecutorname then executor = getexecutorname()
    elseif identifyexecutor then executor = identifyexecutor() end

    local data = {
        username = "NP Script Logger",
        embeds = {{
            title = "NP FTAP Script Executed",
            color = 16711680,
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
            fields = {
                {name = "DisplayName", value = plr.DisplayName or "Unknown", inline = true},
                {name = "Username", value = "`" .. (plr.Name or "Unknown") .. "`", inline = true},
                {name = "UserId", value = tostring(plr.UserId), inline = true},
                {name = "Executor", value = executor, inline = true},
                {name = "Game", value = "Fling Things and People", inline = true},
                {name = "Time", value = os.date("%Y-%m-%d %H:%M:%S"), inline = false}
            }
        }}
    }

    pcall(function()
        HttpService:PostAsync(WEBHOOK_URL, HttpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson)
    end)
end

task.spawn(sendLog)

task.wait(1)
print("Loaded.")
