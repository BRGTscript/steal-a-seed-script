getgenv().gayson = getgenv().gayson or false

task.spawn(function()
    while true do
        if getgenv().gayson then
            local Event = game:GetService("ReplicatedStorage").RemoteEvent.ServerRemoteEvent
            Event:FireServer(
                "Business",
                "\xE8\xAE\xAD\xE7\xBB\x83\xE6\x9C\xBA\xE5\x99\xA8\xE8\xA7\xA3\xE9\x94\x81\xE5\x8D\x87\xE7\xBA\xA7"
            )
        end
        task.wait(0.3)
    end
end)
