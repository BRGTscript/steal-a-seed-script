getgenv().InstantPromptActive = getgenv().InstantPromptActive or false

local Workspace = game:GetService("Workspace")

local function instantPrompt(prompt)
    if prompt:IsA("ProximityPrompt") then
        if getgenv().InstantPromptActive then
            prompt.HoldDuration = 0
            prompt.RequiresLineOfSight = false
        else
            prompt.RequiresLineOfSight = false
        end
    end
end

task.spawn(function()
    while task.wait(0.5) do
        if getgenv().InstantPromptActive then
            for _, desc in ipairs(Workspace:GetDescendants()) do
                if desc:IsA("ProximityPrompt") then
                    desc.HoldDuration = 0
                end
            end
        end
    end
end)

Workspace.DescendantAdded:Connect(function(desc)
    if desc:IsA("ProximityPrompt") and getgenv().InstantPromptActive then
        desc.HoldDuration = 0
    end
end)
