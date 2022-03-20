AddCSLuaFile()

-- keep track of hologram count
local holosCount = 0
hook.Add("SeatHolo_HoloCreated", "SeatHolo_HoloCount", function (holo)
    holosCount = holosCount + 1
end)
hook.Add("SeatHolo_HoloDestroyed", "SeatHolo_HoloCount", function ()
    holosCount = math.max(0, holosCount - 1)
end)

concommand.Add("seatholo_destroyholos", function (ply)
    -- go through all vehicles and see if they have a hologram
    for i,vehicle in ipairs(ents.FindByClass("*vehicle*")) do
        if seat_holo.IsValidVehicle(vehicle) then
            local holo = vehicle:GetVar("SeatHolo_holo", NULL)
            if IsValid(holo) then
                -- if a hologram exists, remove it
                holo:Remove()
                vehicle:SetVar("SeatHolo_holo", NULL)
                vehicle:SetVar("SeatHolo_forceHolo", false)
                hook.Run("SeatHolo_HoloDestroyed")
            end
        end
    end
end)

hook.Add("PopulateToolMenu", "SeatHoloSettings", function ()
    spawnmenu.AddToolMenuOption("Options", "Seat Holo", "SeatHoloSettings", "Settings", "", "", function (form)
        form:CheckBox("Enable Seat Holo", "seatholo_enabled")
        form:NumSlider("Hologram alpha", "seatholo_alpha", 0, 255, 0)
        form:CheckBox("Hologram flickers (not affected by alpha)", "seatholo_flicker")
        form:CheckBox("Attempt avoiding Outfitter playermodel", "seatholo_no_outfitter")
        
        -- holograms button logic

        -- hologram counter
        local holosCounter = Label("Created holograms: 0", form)
        form:AddItem(holosCounter)

        -- button
        local destroyBtn = form:Button("Destroy created holograms", "seatholo_destroyholos")
        local function UpdateElements()
            holosCounter:SetText("Created holograms: " .. holosCount)
            destroyBtn:SetEnabled(holosCount > 0)
        end
        hook.Add("SeatHolo_HoloCreated", "SeatHolo_DestroyBtn", UpdateElements)
        hook.Add("SeatHolo_HoloDestroyed", "SeatHolo_DestroyBtn", UpdateElements)

        UpdateElements()
    end)
end)
