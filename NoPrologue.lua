--Version 1.1
--7/28/2022
--Originally Written by NiJoJa

--INSTRUCTIONS
-- 1. Start a NEW richter save file while this code is running.
-- 2. Enjoy

local function Nologue()	--No Prologue -> Nologue. Funny right?
		mainmemory.writebyte(0x03CA90, 1) --Disable Maria Meeting
		mainmemory.writebyte(0x097BFC, 4) --Setting Subweapon to Cross (for +5 MP)
		mainmemory.writebyte(0x03C9A0, 0) --Setting Character to Alucard
		--mainmemory.writebyte(0x097BA8, 0) --Hearts back to 0 after 3 frames
end

while true do
	if mainmemory.readbyte(0x03C9A0) == 1 then
		Nologue()
	end
	emu.frameadvance();
end

--UPDATES
--1.0 Prologue Skip & MP reward 
	--5/9/2022
--1.1 Fixes the Maria/Randomizer Glitch