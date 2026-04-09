local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local plr = Players.LocalPlayer

local WEBHOOK_URL = "https://webhook.lewisakura.moe/1491747700008292563/iV1-Z0BdzkwOxoPO65VSXDiEcktEHYO2RoB1IF-nEWQ2obWybh6KXBPaPTsznUYFL9J_"

local function sendLog()
    local executor = "Unknown"
    if syn then executor = "Synapse X"
    elseif fluxus then executor = "Fluxus"
    elseif Delta then executor = "Delta Executor"
    elseif getexecutorname then executor = getexecutorname() end

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

task.wait(1.2)
print("Loaded.")
