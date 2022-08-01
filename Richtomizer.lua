--Richtomizer 0.0


Zone 			= 0x0974A0
ZoneSprite 		= 0x097918
Area 			= 0x1375BD
Character 		= 0x03C9A0
RichterReference= 0x07342C

ScreenState		= 0x03C9A4
MenuOpen		= 0x0973EC 
MapOpen			= 0x0974A4
EquipOpen		= 0x137948
RelicOpen		= 0x1FFF6A

GameStart		= 0
ZoneReference 	= 0
LoadingLatch 	= 0
SuccSwitch 		= 0
z31Active		= 0
Paused			= 0


local function SetUp()
	mainmemory.writebyte(0x03CA38, 0) 	--MinoWolf
	mainmemory.writebyte(0x03CA4C, 0) 	--Succubus
	mainmemory.writebyte(0x03CA58, 0) 	--Death
	mainmemory.writebyte(0x03CA60, 0)	--SaveRick 
	mainmemory.writebyte(0x03BE81, 0)	--RickScene
	mainmemory.writebyte(0x097964, 0)	--BatSoul
	mainmemory.writebyte(0x097965, 0)	--Bat2
	mainmemory.writebyte(0x097965, 0)	--Bat3
	mainmemory.writebyte(0x097966, 0)	--Bat4
	mainmemory.writebyte(0x097967, 0)	--Bat5
	mainmemory.writebyte(0x097968, 0)	--WolfSoul
	mainmemory.writebyte(0x097969, 0)	--Wolf2
	mainmemory.writebyte(0x09796A, 0)	--Wolf3
	mainmemory.writebyte(0x09796B, 0)	--MistSoul
	mainmemory.writebyte(0x09796C, 0)	--Mist2
	mainmemory.writebyte(0x09796D, 0)	--Mist3
	mainmemory.writebyte(0x09796E, 0)	--CubeOZoe
	mainmemory.writebyte(0x09796F, 0)	--SpirtOrb 
	mainmemory.writebyte(0x097970, 0)	--Relic0
	mainmemory.writebyte(0x097971, 0)	--LeapRock
	mainmemory.writebyte(0x097972, 0)	--HolySymb
	mainmemory.writebyte(0x097973, 0)	--FaryScrl
	mainmemory.writebyte(0x097974, 0)	--JewelOpn
	mainmemory.writebyte(0x097975, 0)	--Merman
	mainmemory.writebyte(0x09797D, 0)	--Heart-o-Vlad
	mainmemory.writebyte(0x09797E, 0)	--Tooth-o-Vlad
	mainmemory.writebyte(0x09797F, 0)	--Rib-o-Vlad
	mainmemory.writebyte(0x097980, 0)	--Ring-o-Vlad
	mainmemory.writebyte(0x097981, 0)	--Eye-o-Vlad
	--mainmemory.writebyte(0x03BE21, 0)	--Death's First Appearance
	mainmemory.writebyte(0x03BE4E, 0)	--Unknown2
	mainmemory.writebyte(0x03BE4F, 0)	--Unknown3
	mainmemory.writebyte(0x03BE71, 0)	--Unknown4
	mainmemory.writebyte(0x03BE82, 0)	--Unknown5
	mainmemory.writebyte(0x03CA90, 1)	--NoMaria
	mainmemory.writebyte(0x03BEC0, 1)	--SuccScene
	mainmemory.writebyte(0x03C9A0, 1)	--Become Richter
end

local function Zone31(switch, realzone)
	if switch == 0 then
		z31Active = 0
		mainmemory.writebyte(Character, 1)
		mainmemory.writebyte(Zone, realzone)
	elseif switch == 1 then
		z31Active = 1
		mainmemory.writebyte(Zone, 31)
		mainmemory.writebyte(Character, 0)
	end
end

local function SuccubusException(a)
	if a == 50 and mainmemory.readbyte(0x03CA4C) == 0 then
		SuccSwitch = 1
		mainmemory.writebyte(0x03BEC0, 1)
		Zone31(0, ZoneReference)
	elseif a == 48 then
		Zone31(1, ZoneReference)
	end
	if mainmemory.readbyte(0x03CA4C) > 0 then
		SuccSwitch = 0
	end
end

local function PauseCheck(pstatus)
	if pstatus == 112  and Paused == 0 then	--if Richter pauses the game open the menu
		Paused = 1
		mainmemory.writebyte(ScreenState, 2)
	elseif pstatus == 2 and RelicOpen == 1 then
		mainmemory.writebyte(ScreenState, 112)
		mainmemory.writebyte(MenuOpen, 0)
	end
end

local function ZoneCheck(realzone, charloaded)
	if SuccSwitch == 0 then
		if ZoneReference ~= realzone then --Checks Loading Zone
			ZoneReference = realzone
			Zone31(0, ZoneReference)
		elseif charloaded == 0 or LoadingLatch == 1 then --Checks Loading
			LoadingLatch = 1
			if charloaded ~= 0 then	--Checks Loading Complete
				LoadingLatch = 0
				ZoneReference = realzone
				Zone31(1, ZoneReference)
			end
		end
		SuccubusException(mainmemory.readbyte(Area))
	end

end

local function GameState()
	if mainmemory.readbyte(Zone) == 65 then	--Checks for Start of Game)
		SetUp()
		if mainmemory.readbyte(ZoneSprite) == 65 then
			GameStart = 1
			LoadingLatch = 1
		end
	end
	if GameStart == 1 then
		ZoneCheck(mainmemory.readbyte(ZoneSprite), mainmemory.readbyte(RichterReference))
		PauseCheck(mainmemory.readbyte(ScreenState))
	end
end

while true do
	GameState()
	emu.frameadvance();
end