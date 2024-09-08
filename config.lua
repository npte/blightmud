

alias.add("^test$", function (p) mud.send("say " .. msdp.get("MANA")) end)
alias.add("^test1$", function (p) mud.send("say " .. my) end)

mud.on_connect(function (host, port)
    blight.output("Connected to:", host, port)
end)

mud.on_connect(function (host, port)
    
end)

--msdp
msdpVars = {"CHARACTER_NAME", "TANK_NAME", "GROUP_LEADER", "HEALTH", "HEALTH_MAX", "MANA", "MANA_MAX", "MOVEMENT", "MOVEMENT_MAX", "AFFECTS", "AC", "GROUP", "POSITION"};

core.on_protocol_enabled(function (proto)
     if proto == 69 then -- Check for MSDP
        for i = 1,#msdpVars do msdp.report(msdpVars[i]); end;
    end
end)

tankName = "";
msdp.register("TANK_NAME", function (var) tankName = var end);

target = "";
leaderName = "";
msdp.register("GROUP_LEADER", function (var) leaderName = var; end);

myName = "";
msdp.register("CHARACTER_NAME", function (var) myName = var end);
myPosition = "";
msdp.register("POSITION", function (var) myPosition = var end);
myAc = "";
msdp.register("AC", function (var) myAc = var end);

myHp = "";
msdp.register("HEALTH", function (var) myHp = var end);
myHpMax = "";
msdp.register("HEALTH_MAX", function (var) myHpMax = var end);
myMa = "";
msdp.register("MANA", function (var) myMa = var end);
myMaMax = "";
msdp.register("MANA_MAX", function (var) myMaMax = var end);
myMv = "";
msdp.register("MOVEMENT", function (var) myMv = var end);
myMvMax = "";
msdp.register("MOVEMENT_MAX", function (var) myMvMax = var end);

function processGroup()
   local tank, leader, me
   groupreport = ""

   --Determine who is what in the group
   for key,value in pairs(group) do
      if group[key]["NAME"] == tankName then
         tank = key
      end
      if group[key]["NAME"] == myName then
         me = key
      end
      if group[key]["POSITION"] == "Pleader" then
         leader = key
      end
      if tonumber(group[key]["HITPOINTS"]) <= -10 then
         groupreport = groupreport.."\n"..group[key]["NAME"].." is Dead." 
      end
      if tonumber(group[key]["HITPOINTS"]) >= -9 and tonumber(group[key]["HITPOINTS"]) <= 0 then
         groupreport = groupreport.."\n"..group[key]["NAME"].." is Incap." 
      end
      if tonumber(group[key]["HITPOINTS"]) > 0 and tonumber(group[key]["HITPOINTS"]) <= 100 then
         groupreport = groupreport.."\n"..group[key]["NAME"].." is Dying." 
      end
   end

   --Assist the tank, if I am with group and he is fighting
   if tankName ~= myName then
      if group[tank]["STATUS"] == "Fighting" and myPosition ~= "Fighting" and group[me]["STATUS"] ~= "Absent" then
         mud.send("assist "..tankName)
      elseif group[tank]["STATUS"] == "Fighting" and group[me]["STATUS"] == "Absent" then
         blight.output("THE TANK IS FIGHTING, I AM ABSENT!")
      end
   end

   --Man back if I am in the front row
   if group[me]["POSITION"] == "Front" then
      mud.send("man back")
   end
end

group = {}
msdp.register("GROUP", function (var) group = var; processGroup(); end);
affects = {}
msdp.register("AFFECTS", function (var) affects = var end);

alias.add("^was$", function (p)
	if myPosition == "Standing" then mud.send(""); return; end;
	if myPosition == "Sleeping" then mud.send("wake\r\nstand"); return; end;
	if myPosition == "Sitting" then mud.send("stand"); return; end;
	if myPosition == "Resting" then mud.send("stand"); return; end;
end)

trigger.add("^(\\w+) -- 'target (\\w+)'$", {}, function (matches)
	if matches[2] == leaderName then 
		target = matches[3]; 
	end;
end)
trigger.add("^(\\w+) -- 'visage'$", {}, function (matches)
	if matches[2] == leaderName then 
		mud.send("cast 'undead visage'"); 
	end;
end)
trigger.add("^(\\w+) -- 'recall'$", {}, function (matches)
	if matches[2] == leaderName then 
		mud.send("cast 'word of recall'"); 
	end;
end)
trigger.add("^(\\w+) -- 'mindbar'$", {}, function (matches)
	if matches[2] == leaderName then 
		mud.send("cast 'mindbar'"); 
	end;
end)
trigger.add("^(\\w+) -- 'spectral'$", {}, function (matches)
	if matches[2] == leaderName then 
		mud.send("cast 'spectral'"); 
	end;
end)
trigger.add("^(\\w+) -- 'all up'$", {}, function (matches)
	if matches[2] == leaderName then 
		mud.send("wake\r\nstand"); 
	end;
end)
trigger.add("^(\\w+) -- 'drop choppers'$", {}, function (matches)
	if matches[2] == leaderName then
		mud.send("rem chopper\r\ndrop all.chopper"); 
	end;
end)
trigger.add("^(\\w+) -- 'portal'$", {}, function (matches)
	if matches[2] == leaderName then 
		mud.send("enter portal"); 
	end;
end)
trigger.add("^(\\w+) steps through the portal and disappears!$", {}, function (matches)
	if matches[2] == leaderName then 
		mud.send("enter portal"); 
	end;
end)
trigger.add("^(\\w+) has just entered the portal\\.$", {}, function (matches)
	if matches[2] == leaderName then 
		mud.send("enter portal"); 
	end;
end)
trigger.add("^(\\w+) enters the glowing archway and disappears from sight!$", {}, function (matches)
	if matches[2] == leaderName then 
		mud.send("enter archway"); 
	end;
end)
trigger.add("^(\\w+) enters the archway and disappears from sight\\.$", {}, function (matches)
	if matches[2] == leaderName then 
		mud.send("enter archway"); 
	end;
end)