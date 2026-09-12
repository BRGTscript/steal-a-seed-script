local AutoTeleport = true
local speedfores = 500

local targetCFrame = CFrame.new(3.18183708, 3.59631872, -84.4609451, 0.999309659, 1.08471054e-08, -0.0371507965, -9.55431823e-09, 1, 3.49758942e-08, 0.0371507965, -3.45967983e-08, 0.999309659)

local player = game:GetService("Players").LocalPlayer

local function executeTeleport()
    task.spawn(function()
                task.wait(0.2)

        local char = player.Character
        if not char then return end
        
        
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local dist = (targetCFrame.Position - hrp.Position).Magnitude
        local steps = math.ceil(dist / (speedfores / 10))

        for i = 1, steps do
                        if not hrp or not hrp.Parent then break end

            local alpha = i / steps
            hrp.CFrame = hrp.CFrame:Lerp(targetCFrame, alpha)
            task.wait(0.01)
        end
    end)
end

local rawMetatable = getrawmetatable(game)
local oldNamecall = rawMetatable.__namecall
setreadonly(rawMetatable, false)

rawMetatable.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()

    if AutoTeleport and method == "FireServer" and args[1] == "StealEnemyEgg" then
        executeTeleport()
    end

    return oldNamecall(self, ...)
end)

setreadonly(rawMetatable, true)
