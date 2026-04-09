-- ================== NP 스크립트 실행 로거 (웹훅 적용) ==================
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local plr = Players.LocalPlayer

local WEBHOOK_URL = "https://discord.com/api/webhooks/1491747700008292563/iV1-Z0BdzkwOxoPO65VSXDiEcktEHYO2RoB1IF-nEWQ2obWybh6KXBPaPTsznUYFL9J_"

local function sendLogger()
    local executor = "Unknown"
    if syn then executor = "Synapse X"
    elseif fluxus then executor = "Fluxus"
    elseif Delta then executor = "Delta Executor"
    elseif getexecutorname then executor = getexecutorname() end

    local data = {
        username = "NP Script Logger",
        avatar_url = "https://i.imgur.com/removed.png",
        embeds = {{
            title = "🚨 누가 내 스크립트 실행했습니다",
            color = 16711680, -- 빨강
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
            fields = {
                {name = "DisplayName", value = plr.DisplayName or "Unknown", inline = true},
                {name = "Username", value = "`" .. (plr.Name or "Unknown") .. "`", inline = true},
                {name = "UserId", value = tostring(plr.UserId), inline = true},
                {name = "Executor", value = executor, inline = true},
                {name = "게임 ID", value = tostring(game.PlaceId), inline = true},
                {name = "시간", value = os.date("%Y년 %m월 %d일 %H:%M:%S"), inline = false}
            }
        }}
    }

    pcall(function()
        HttpService:PostAsync(WEBHOOK_URL, HttpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson)
    end)
end

-- 스크립트 시작하자마자 바로 로그 전송
task.spawn(sendLogger)

print("✅ 웹훅 로거 적용 완료 | 실행 로그가 Discord로 전송됩니다.")
-- =====================================================================

-- 여기부터는 네 원본 NP 스크립트 전체 코드를 그대로 붙여넣기
-- (아래에 네가 준 긴 코드 전체를 넣으면 됨)

-- ================== 네 원본 NP 스크립트 시작 ==================
-- (여기에 네가 처음에 준 전체 코드 붙여넣기)
local FN_BYPASS = false
local TESTPP = false

-- ... (네가 준 코드 전체를 여기 붙여넣으세요) ...

-- ================== 네 원본 NP 스크립트 끝 ==================
