-- NOTE: i originally intended this entire code to be completely clientside lol

if CLIENT then

CreateClientConVar("seatholo_enabled", "1", true, false, "Enables Seat Holo.")
CreateClientConVar("seatholo_no_outfitter", "0", true, false, "Attempt to not use an Outfitter playermodel.")
CreateClientConVar("seatholo_transparent", "1", true, false, "Make the hologram transparent.")
CreateClientConVar("seatholo_flicker", "1", true, false, "If the hologram is transparent, should it flicker?")

local aimed = NULL
local SHholo = NULL

hook.Add("Think", "SeatHolo_Hook", function()
	if not GetConVar("seatholo_enabled"):GetBool() then
		if IsValid(SHholo) then SHholo:Remove() end -- if we still have a holo prop, remove it so that the it doesn't get stuck always appearing
		return
	end
	
	aimed = util.TraceLine({start=LocalPlayer():EyePos(),endpos=LocalPlayer():EyePos() + LocalPlayer():GetAimVector() * 128,filter=LocalPlayer()}).Entity -- traceline of 128 HUnits
	if IsValid(aimed) && not(aimed:IsScripted()) && aimed:IsVehicle() && aimed:GetDriver() == NULL && not(LocalPlayer():InVehicle() or not(LocalPlayer():Alive())) then -- entity is valid, not scripted, is vehicle, has no drivers & player must be alive and not in a vehicle
		-- initial creation
		if !IsValid(SHholo) then -- we don't have a holo prop, let's create it!
			SHholo = ents.CreateClientProp(LocalPlayer():GetModel())
			SHholo:PhysicsDestroy()
			SHholo:DestroyShadow()
			SHholo:SetParent(aimed)
			SHholo:Spawn()
		end
		
		-- ConVars
		if GetConVar("seatholo_no_outfitter"):GetBool() then
			SHholo:SetModel(player_manager.TranslatePlayerModel(GetConVar("cl_playermodel"):GetString())) -- cheap hack for now, it will very much lead to inconsistencies
		else
			SHholo:SetModel(LocalPlayer():GetModel())
		end
		if GetConVar("seatholo_transparent"):GetBool() then
			SHholo:SetRenderMode(1)
			if GetConVar("seatholo_flicker"):GetBool() then
				SHholo:SetRenderFX(16) -- flickering effect, for seatholo_flicker
			else
				SHholo:SetRenderFX(0)
				SHholo:SetColor(Color(255, 255, 255, 192)) -- non-flickering transparency
			end
		else
			SHholo:SetRenderMode(0)
			SHholo:SetRenderFX(0)
			SHholo:SetColor(Color(255, 255, 255, 255))
		end
		
		-- positioning
		local attch_num = aimed:LookupAttachment("vehicle_feet_passenger0") -- check for driver pos attachment
		if attch_num > 0 then -- get the attachment origin and angles if the vehicle has one
			local attch = aimed:GetAttachment(attch_num)
			SHholo:SetPos(attch.Pos)
			SHholo:SetAngles(attch.Ang)
		else -- get the vehicle's origin and angles otherwise
			SHholo:SetPos(aimed:GetPos())
			SHholo:SetAngles(aimed:GetAngles())
		end
		
		-- animation(ing)
		SHholo:SetSequence("drive_jeep") -- currently placeholder, might want to let Bomb do this ! ! a
	elseif (LocalPlayer():InVehicle() || !aimed:IsVehicle() || not(LocalPlayer():Alive())) && IsValid(SHholo) then -- no longer aiming at a vehicle, let's remove the holo prop
		SHholo:Remove()
	end
end)

hook.Add("PopulateToolMenu", "SeatHoloSettings", function()
	spawnmenu.AddToolMenuOption("Options", "Seat Holo", "SeatHoloSettings", "Settings", "", "", function(panel)
		panel:AddControl("CheckBox", {Label = "Enable Seat Holo", Command = "seatholo_enabled"})
		panel:AddControl("CheckBox", {Label = "Transparency", Command = "seatholo_transparent"})
		panel:AddControl("CheckBox", {Label = "Flickering effect", Command = "seatholo_flicker"})
		panel:AddControl("CheckBox", {Label = "Attempt avoiding Outfitter playermodel", Command = "seatholo_no_outfitter"})
	end)
end)

end
