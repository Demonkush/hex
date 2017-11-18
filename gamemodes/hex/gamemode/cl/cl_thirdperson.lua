-- Third Person script by Crashlemon, from the Lment gamemode

plyCamAng = plyCamAng or Angle( 0, 0, 0 )
plyCamPos = plyCamPos or Vector( 0, 0, 0 )
oldCamAng = oldCamAng or Angle( 0, 0, 0 )

-- Creating the Camera:
local f = 100
local r = -25
local u = -15

-- experimental
--[[
hook.Add("Think","HEX_AutoTPY",function()
    if input.IsMouseDown(MOUSE_WHEEL_DOWN) == true then
        SetConVar("hex_cl_thirdpersonpositiony",math.Clamp(GetConVar("hex_cl_thirdpersonpositiony")-1,-30,15))
        print("test1")
    end
    if input.IsMouseDown(MOUSE_WHEEL_UP) == true then
        SetConVar("hex_cl_thirdpersonpositiony",math.Clamp(GetConVar("hex_cl_thirdpersonpositiony")+1,-30,15))
        print("test2")
    end
end)
]]

function ThirdPersonCamera( ply, pos, ang, fov, znear, zfar )
    
    if !IsValid( LocalPlayer( ) ) or !LocalPlayer():Alive() then return end
    local ply = LocalPlayer( )
    
	local forward		= 	plyCamAng:Forward() * f
	local right			= 	plyCamAng:Right() * GetConVar("hex_cl_thirdpersonpositionx"):GetInt()
	local up 			= 	plyCamAng:Up() * GetConVar("hex_cl_thirdpersonpositiony"):GetInt()
    
    if LocalPlayer():Crouching() == true then
        up = up + ( plyCamAng:Up() * -32 )
    end

    local camPos        =   pos - ( forward ) + ( right ) - ( up )
    -- Collision Detection Trace:
    -- Basic collision detection to prevent
    -- camera from going through walls!
    
    local cdTr          =   util.TraceLine( {            
        start           =   ply:EyePos( ),
        endpos          =   camPos,
        filter          =   ply,            
    } )
    
    plyCamPos = cdTr.HitPos
    
    -- Finalizing camera position, angles, etc:

    local cam           =   { }
    
    cam.origin          =   plyCamPos
    cam.angles          =   plyCamAng
    cam.fov             =   fov
    cam.drawviewer      =   true    -- Draw player model!
	
	-- Old camera angles.
	oldCamAng = Angle( cam.angles.p, cam.angles.y, 0 )
	
    return cam
    
end

hook.Add( "CalcView", "ThirdPersonCamera", ThirdPersonCamera )

-- Let mouse movement aim camera and disable
-- mouse aiming for player:

function ThirdPersonAiming( cmd, x, y, ang )
    
    if !IsValid( LocalPlayer( ) ) then return false end
    local ply = LocalPlayer( )
    
    -- Add the mouse values to the camera angle to apply turning!
    -- Fix the angle so it's appropriately between -180 and 180
    -- Clamp it so the player can't go further than 90 degrees
    -- upwards/downwards (otherwise the camera would be able to
    -- be upside down):
    
    plyCamAng.p            = math.Clamp( math.NormalizeAngle( plyCamAng.p + y / 50 ), -90, 90 )
    plyCamAng.y            = math.NormalizeAngle( plyCamAng.y - x / 50 )
	
	local forward		= 	oldCamAng:Forward() * f
	local right			= 	oldCamAng:Right() * r
	local up 			= 	oldCamAng:Up() * u
	
	-- Crosshair Trace:
    -- Finding what the crosshair is aiming at
    
    local chTr          =   util.TraceLine( {
        start           =   plyCamPos + forward * 1,
        endpos          =   plyCamPos + ( plyCamAng:Forward( ) * 32768 ),
        filter          =   ply,
    } )
    
    -- Forcing player to aim at crosshair trace
    -- HitPos:
    
	cmd:SetViewAngles( ( chTr.HitPos - ply:EyePos( ) ):Angle( ) )

    return true -- We changed this, so mark true.
    
end
hook.Add( "InputMouseApply", "ThirdPersonAiming", ThirdPersonAiming )

-- A small function to get the custom cam's position.
function GetCustomCamPos()
	return plyCamPos or self:EyePos()
end

-- A small function to get the custom cam's angles.
function GetCustomCamAngles()
	return plyCamAng
end

-- Get player custom cam trace.
function GetCustomCamTrace()
	
	if ( not customCamTrace or lastCamTrace != CurTime() ) then
		customCamTrace 		= util.TraceLine( {
			start 			= GetCustomCamPos(),
			endpos			= GetCustomCamPos() + GetCustomCamAngles():Forward() * 32768,
			filter			= ply,
			mask			= MASK_SHOT
		} )
	end
	
	-- Return the result
	return customCamTrace
	
end

-- Adjust walk speeds to force player to walk in
-- correct direction relative to camera instead of
-- crosshair:

function ThirdPersonStrafeFix( cmd )

    if !IsValid( LocalPlayer( ) ) then return false end
    local ply = LocalPlayer( )
    
    -- Figure out how far we need to offset player:
    
    local desiredYaw    =   plyCamAng.y
    local currentYaw    =   ply:EyeAngles( ).y
    local offsetYaw     =   desiredYaw - currentYaw
    
    -- correctedYaw will be turned into walk speeds
    -- and mvLength will be a necessary multiplier:
    
    local correctedYaw  =   Vector( cmd:GetForwardMove( ), cmd:GetSideMove( ), 0 )
    local mvLength      =   correctedYaw:Length( )
    correctedYaw        =   correctedYaw:Angle( ).y
    correctedYaw        =   Angle( 0, correctedYaw - offsetYaw, 0 )
    correctedYaw        =   correctedYaw:Forward( )
    
    cmd:SetForwardMove( correctedYaw.x * mvLength )
    cmd:SetSideMove( correctedYaw.y * mvLength )
    
    return true -- We changed this, so mark true.
    
end

hook.Add( "CreateMove", "ThirdPersonStrafeFix", ThirdPersonStrafeFix )

-- Add a hook to switch from right to left.
hook.Add( "KeyPress", "TPRightLeft", function( ply, key )
	if ( key == IN_ZOOM ) then r = r * -1 end
end)

hook.Add("ShouldDrawLocalPlayer", "SW ShouldDrawLocalPlayer", function(ply)
        return true
end)