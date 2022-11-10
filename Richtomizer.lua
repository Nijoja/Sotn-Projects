--Richtomizer 1.0
--11/2/2022
--Originally Written by NiJoJa

--INSTRUCTIONS
--1. Reset your Emulator (BIZHAWK: Emulation tab -> Soft Reset)
--2. Open this code at the FILE SELECT screen (BIZHAWK: via the Lua Console)
--3. To Play the prologue still, enter any name. To get right into the game enter RICHTER.


Zone 			= 0x0974A0
Zone_Sprite 	= 0x097918
Character 		= 0x03C9A0
Richter_Sprite	= 0x07342C

In_Menu 		= 0
In_Save			= 0
Game_Start		= 0
Jumping			= 0

Boss_Switch		= 0
Boss_IDs		= {"MiWo","MiWo","Hipo","Hipo","Rich","Scyl","Olro","Succ","Cerb","GrFa","Dop10","Dop10","Medu","Medu","Akmo","Trio","Trio","Dop40"}
Boss_Comp_IDs   = {0x03CA38,0x03CA38,0x03CA44,0x03CA44,0x03CA60,0x03CA3C,0x03CA2C,0x03CA4C,0x03CA5C,0x03CA34,0x03CA30,0x03CA30,0x03CA64,0x03CA64,0x03CA74,0x03CA54,0x03CA54,0x03CA70}
Boss_X_Pos		= {18,21,22,25,34,39,21,45,29,20,56,59,38,41,42,42,45,24}
Boss_Y_Pos		= {22,22,13,13,08,39,16,33,40,50,23,23,50,50,47,41,41,24}

--Sets all necessary game variables to respective values
local function Set_Up()
	if mainmemory.readbyte(Zone) == 65 then
		mainmemory.writebyte(0x03CA38, 0) 	--MinoWolf
		mainmemory.writebyte(0x03CA39, 0) 	--MinoWolf b2
		mainmemory.writebyte(0x03CA4C, 0) 	--Succubus
		mainmemory.writebyte(0x03CA4D, 0) 	--Succubus b2
		mainmemory.writebyte(0x03CA58, 0) 	--Death
		mainmemory.writebyte(0x03CA59, 0) 	--Death b2
		mainmemory.writebyte(0x03CA60, 0)	--SaveRick 
		mainmemory.writebyte(0x03CA61, 0)	--SaveRick b2
		mainmemory.writebyte(0x03BE81, 0)	--RickScene
		mainmemory.writebyte(0x097964, 0)	--BatSoul
		mainmemory.writebyte(0x097965, 0)	--Bat2
		mainmemory.writebyte(0x097966, 0)	--Bat3
		mainmemory.writebyte(0x097967, 0)	--Bat4
		mainmemory.writebyte(0x097968, 0)	--WolfSoul
		mainmemory.writebyte(0x097969, 0)	--Wolf2
		mainmemory.writebyte(0x09796A, 0)	--Wolf3
		mainmemory.writebyte(0x09796B, 0)	--MistSoul
		mainmemory.writebyte(0x09796C, 0)	--Mist2
		mainmemory.writebyte(0x09796D, 0)	--Mist3
		mainmemory.writebyte(0x09796E, 0)	--CubeOZoe
		mainmemory.writebyte(0x09796F, 0)	--SpirtOrb
		mainmemory.writebyte(0x097970, 0)	--GravBoots
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
		mainmemory.writebyte(0x03BE82, 1)	--RCS2
		mainmemory.writebyte(0x03CA90, 1)	--NoMaria
		mainmemory.writebyte(0x03BEC0, 1)	--SuccScene
	end
	mainmemory.writebyte(0x03C9A0, 1)	--Become Richter
end

--Enables Prologue Richter (Item Pickups)
local function Zone_31(switch, real_zone)
	if switch == 0 then	--OFF
		mainmemory.writebyte(Character, 1)
		mainmemory.writebyte(Zone, real_zone)
	elseif switch == 1 then	--ON
		mainmemory.writebyte(Zone, 31)
		mainmemory.writebyte(Character, 0)
	end
end

--Disables Prologue Richter Selectively near boss rooms
local function Boss_Exceptions()
	--X,Y is determined by position + offset
	xp = mainmemory.readbyte(0x0730B0)
	xo = mainmemory.readbyte(0x0973F1)
	yp = mainmemory.readbyte(0x0730B4)
	yo = mainmemory.readbyte(0x0973F5)
	x = xp + xo
	y =	yp + yo
	
	for i = 1 , table.getn(Boss_IDs) do --If you are about to fight a boss disable hacks
		if x == Boss_X_Pos[i] and y == Boss_Y_Pos[i] and mainmemory.readbyte(Boss_Comp_IDs[i]) == 0 then 
			Boss_Switch = Boss_Comp_IDs[i]
			Zone_31(0, mainmemory.readbyte(Zone_Sprite))
		elseif x == Boss_X_Pos[i] and y == Boss_Y_Pos[i] and mainmemory.readbyte(Boss_Comp_IDs[i]) ~= 0 and mainmemory.readbyte(0x03C9A4) == 1 and not (xo == 2 and mainmemory.readbyte(0x072F9C) > 250) then 
			In_Save = 1
		end
	end

	if mainmemory.readbyte(Zone) == 31 then--Allows teleport to 2nd castle
		if x == 31 and y == 8 then	
			Zone_31(0, 11)
		elseif x == 32 and y == 56 then --And vice versa
			Zone_31(0, 43)
		end
	elseif mainmemory.readbyte(Zone) ~= 31 then--Renenables hacks
		if x == 32 and y == 8 then	
			Zone_31(1, 11)
		elseif x == 32 and y == 55 then --And vice versa
			Zone_31(1, 43)
		end
	end
end

--Checks to see if trying to load (CD room)
local function Zone_Check(real_zone)
	if Boss_Switch == 0 then
		if mainmemory.readbyte(0x03C708) > 0 or mainmemory.readbyte(0x072EFC) == 3	then	--Checks for Save/CD Rooms
			In_Save = 1
			Zone_31(0, real_zone)
		elseif In_Save == 1 then
			In_Save = 0
			Zone_31(1, 0)
		end
		Boss_Exceptions()
		
	elseif Boss_Switch == Boss_Comp_IDs[5] and mainmemory.readbyte(Boss_Switch) == 0 then --Richter Fight Custom Code
		if mainmemory.readbyte(0x0762EE) == 32 then
			mainmemory.writebyte(0x03BE81, 1)
		elseif mainmemory.readbyte(0x0762EE) == 44 then
			mainmemory.writebyte(0x03BE81, 0)
			mainmemory.writebyte(0x0762EE, 53)
		end
	elseif mainmemory.readbyte(Boss_Switch) ~= 0 then --When the boss is beaten, resume zone checks
		Boss_Switch = 0
	end
end

--Disables ablitlies
local function Disabler(lock_ID, move_ID)
	if lock_ID == 0 and mainmemory.readbyte(0x074B7E) == move_ID then
		mainmemory.writebyte(0x072EFC, 255)
		mainmemory.writebyte(0x072F60, 53)
		mainmemory.writebyte(0x072F61, 1)
		mainmemory.writebyte(0x072F09, 2)
		
	end
	if mainmemory.readbyte(0x072F08) > 0 and mainmemory.readbyte(0x073404) < 3 then
		mainmemory.writebyte(0x072EFC, 0)
		mainmemory.writebyte(0x072F08, 0)
	end
end

--Applies modifiers coresponding to Bat Relics
local function Bat_Relics()
--Whip is buffed by bat relics. 2, 8, 18, 32 damage
	Whip_Mod = ((mainmemory.readbyte(0x097964) + mainmemory.readbyte(0x097965) + mainmemory.readbyte(0x097966) + mainmemory.readbyte(0x097967))/3)^2 * 2
	Whip_Dmg = 32 + Whip_Mod
	mainmemory.writebyte(0x1547A0, Whip_Dmg)
end

--Applies modifiers coresponding to Wolf Relics
local function Wolf_Relics()
--Slide is buffed by wolf relics. 5,20,45 damage
	Slide_Mod = ((mainmemory.readbyte(0x097968) + mainmemory.readbyte(0x097969) + mainmemory.readbyte(0x09796A))/3)^2 * 5
	Slide_Dmg = 20 + Slide_Mod
	SlideKick_Dmg = 60 + Slide_Mod
	mainmemory.writebyte(0x1547F0, Slide_Dmg)
	mainmemory.writebyte(0x154854, SlideKick_Dmg)
--Form of Wolf Enables Consecutive Slide
	Disabler(mainmemory.readbyte(0x097968), 23)
end

--Applies modifiers coresponding to Mist Relics
local function Mist_Relics()
--Dash is buffed by Mist Relics. 5, 10, 15 damage
	Dash_Mod = (mainmemory.readbyte(0x09796B) + mainmemory.readbyte(0x09796C) + mainmemory.readbyte(0x09796D))/3 * 5
	Dash_Dmg = 80 + Dash_Mod
	mainmemory.writebyte(0x1547DC, Dash_Dmg)
--Power of Mist Enables Consecutive Dash
	Disabler(mainmemory.readbyte(0x09796C), 24)
end

--Applies modifiers coresponding to Jump Relics
local function Jump_Relics()
--Uppercut is buffed by Jump Relics. 15, 30 damage
	Jump_Mod = (mainmemory.readbyte(0x097970) + mainmemory.readbyte(0x097971)) * 5
	Jump_Dmg = 80 + Jump_Mod
	mainmemory.writebyte(0x154840, Jump_Dmg)
--Leapstone Enables Double Jump
	if mainmemory.readbyte(0x073404) == 4 and mainmemory.readbyte(0x097971) > 0 and mainmemory.readbyte(0x072EF0) == 64 and Jumping == 0 then --Checks for jumping
		Jumping = 1	
	end
	if Jumping == 1 and mainmemory.readbyte(0x072EF0) ~= 64 then
		Jumping = 2
		mainmemory.writebyte(0x15E2D6, 65)
	end
	if Jumping == 2 and mainmemory.readbyte(0x072EF0) == 64 then
		mainmemory.writebyte(0x15E2D6, 64)
		Jumping = 3
	end
	if Jumping > 1 and (mainmemory.readbyte(0x073404) < 3 or mainmemory.readbyte(0x073404) == 25) then
		Jumping = 0
		mainmemory.writebyte(0x15E2D6, 64)
	end
--Gravity Boots Enables Consecutive Uppercut
	Disabler(mainmemory.readbyte(0x097970), 29)
end

--Applies modifiers coresponding to Mage Relics
local function Mage_Relics()
--Subweapons are buffed by Other Relics 1.25, 1.5, 1.75, 2, 2.25, 2.5 damage
	Sub_Mod = (mainmemory.readbyte(0x09796E) + mainmemory.readbyte(0x09796F) + mainmemory.readbyte(0x097972) + mainmemory.readbyte(0x097973) + mainmemory.readbyte(0x097974))/12
	Low_Dmg = 8 * (1 + Sub_Mod)
	mainmemory.writebyte(0x1546EC, Low_Dmg)
	mainmemory.writebyte(0x154764, Low_Dmg)
	Med_Dmg = 20 * (1 + Sub_Mod)
	mainmemory.writebyte(0x154728, Med_Dmg)
	mainmemory.writebyte(0x15473C, Med_Dmg)
	mainmemory.writebyte(0x15469C, Med_Dmg)
	Hig_Dmg = 50 * (1 + Sub_Mod)
	mainmemory.writebyte(0x1546D8, Hig_Dmg)
	mainmemory.writebyte(0x154714, Hig_Dmg)
	mainmemory.writebyte(0x1546B0, Hig_Dmg)
end

--Calls the other relic functions
local function Relic_Check()
	Bat_Relics()
	Wolf_Relics()
	Mist_Relics()	
	Jump_Relics()
	Mage_Relics()
end

--Checks for key items and equips them
local function Item_Check()
--Holy Glasses
	if mainmemory.readbyte(0x097A55) > 0 then
		mainmemory.writebyte(0x097C08, 34)
	end
--Spike Breaker
	if mainmemory.readbyte(0x097A41) > 0 then
		mainmemory.writebyte(0x097C0C, 14)
	end
--Silver Ring
	if mainmemory.readbyte(0x097A7C) > 0 then
		mainmemory.writebyte(0x097C14, 73)
	end
--Gold Ring 
	if mainmemory.readbyte(0x097A7B) > 0 then
		mainmemory.writebyte(0x097C18, 72)
	end
end

--Manages New Game vs Loaded Save
local function Start_Menu()
	if mainmemory.readbyte(Zone) == 69 or In_Menu == 1 then
		if mainmemory.readbyte(Zone) ~= 69 and mainmemory.readbyte(Zone) ~= 31 then	--Checks for Start of Game
			Set_Up()
			if mainmemory.readbyte(Zone_Sprite) == mainmemory.readbyte(Zone) then --Checks if game is started
				if mainmemory.readbyte(Richter_Sprite) > 0 then
					Set_Up()
					In_Menu = 0
					In_Save = 1
					Game_Start = 1
				end
				return
			end
		end
		In_Menu = 1
	end
end

--Disables hacks in event of Death
local function Health_Check(hp, real_zone)
	if hp < 1 then 
		Zone_31(0, real_zone)
		Game_Start = 0
	end
end

--Monitors the state of the game
local function Game_State()
	Start_Menu()
	if Game_Start == 1 then
		Zone_Check(mainmemory.readbyte(Zone_Sprite))
		Relic_Check()
		Item_Check()
		Health_Check(mainmemory.readbyte(0x097BA0), mainmemory.readbyte(Zone_Sprite))
	end
end

while true do
	Game_State()
	emu.frameadvance();
end

--KNOWN ISSUES
--Cannot Sprint through Doors
--No Map