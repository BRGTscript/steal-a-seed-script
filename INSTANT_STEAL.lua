getgenv().InstantPromptActive = getgenv().InstantPromptActive or false

local Workspace = game:GetService("Workspace")

task.spawn(function()
    while task.wait(0.5) do
        for _, desc in ipairs(Workspace:GetDescendants()) do
            if desc:IsA("ProximityPrompt") then
                if getgenv().InstantPromptActive then
                    desc.HoldDuration = 0
                    desc.RequiresLineOfSight = false
                else
                    desc.HoldDuration = 2
                end
            end
        end
    end
end)

Workspace.DescendantAdded:Connect(function(desc)
    if desc:IsA("ProximityPrompt") then
        if getgenv().InstantPromptActive then
            desc.HoldDuration = 0
            desc.RequiresLineOfSight = false
        else
            desc.HoldDuration = 2
        end
    end
end)
