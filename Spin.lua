local Spin = {}
Spin.optionEnable = Menu.AddOption({"mlambers", "Spin"}, "1. Enable", "")
Spin.optionKey = Menu.AddKeyOption({"mlambers", "Spin"}, "2. Key for activate",Enum.ButtonCode.KEY_D)

local tick = 0
local MyHero, MyPlayer = nil, nil
local angle, direction, origin = nil, nil, nil

function Spin.OnScriptLoad()
	tick = 0
	angle, direction, origin = nil, nil, nil
	MyHero, MyPlayer = nil, nil
	
	Console.Print("[" .. os.date("%I:%M:%S %p") .. "] - - [ Spin.lua ] [ Version 0.2 ] Script load.")
end

function Spin.OnGameEnd()
	tick = 0
	angle, direction, origin = nil, nil, nil
	MyHero, MyPlayer = nil, nil
	
	Console.Print("[" .. os.date("%I:%M:%S %p") .. "] - - [ Spin.lua ] [ Version 0.2 ] Game end. Reset all variable.")
end

function Spin.OnUpdate()
	if Menu.IsEnabled(Spin.optionEnable) == false then return end
  
	if MyHero == nil or MyHero ~= Heroes.GetLocal() then 
		tick = 0
		angle, direction, origin = nil, nil, nil
		MyHero = Heroes.GetLocal()
		MyPlayer = Players.GetLocal()
		
		Console.Print("[" .. os.date("%I:%M:%S %p") .. "] - - [ Spin.lua ] [ Version 0.2 ] Game started, init script done.")
		return
	end
  
	if Entity.IsAlive(MyHero) and Menu.IsKeyDown(Spin.optionKey) and Input.IsInputCaptured() == false then
		if tick <= GlobalVars.GetTickTime() then
			angle = Entity.GetRotation(MyHero)
			angle:SetYaw(angle:GetYaw() + Angle(0, 168.5, 0):GetYaw())
			
			direction = angle:GetForward() + angle:GetRight() + angle:GetUp()
			direction:SetZ(0)
			direction:Normalize()
			direction:Scale(1)
			
			origin = NPC.GetAbsOrigin(MyHero)
			
			Player.PrepareUnitOrders(MyPlayer, Enum.UnitOrder.DOTA_UNIT_ORDER_MOVE_TO_POSITION, MyHero, (origin + direction), nil, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_HERO_ONLY)
			
			
			--tick = GlobalVars.GetTickTime() + ((0.03 / NPC.GetTurnRate(MyHero)) * 2.94) + ((NetChannel.GetAvgLatency(Enum.Flow.FLOW_INCOMING) + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)) * 2)
			tick = GlobalVars.GetTickTime() + NPC.GetTimeToFacePosition(MyHero, (origin + direction)) + ((NetChannel.GetAvgLatency(Enum.Flow.FLOW_INCOMING) + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)) * 2)
		end
	end
end

return Spin