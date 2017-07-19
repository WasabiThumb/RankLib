-- Don't touch this stuff! We need it to work!

function readrankname( id )
  local tab = util.JSONToTable( file.Read("ranklist.txt") )
  return tab[1];
end

function hasperm( id, permname )
  local nam = (tostring(id) .. ".txt");
  local tab = util.JSONToTable( file.Read(nam) )
  return tab[permname]
end

function setrank( player, id )
  local ply = getplayerbyname( player )
  local nam = ("plylist/" tostring(id) .. ".txt");
  if !ply then return end
  if !file.Exists("plylist", "DATA") then file.CreateDir("plylist") end
  if !file.Exists(nam, "DATA") then file.Write(nam, "") end
  local tabl1 = { ply }
  local tabl2 = util.JSONToTable( file.Read(nam, "DATA") )
  local newcont = util.TableToJSON( table.Add( tabl1, tabl2 );
  if (tabl2 == "") then newcont = tabl1 end
  revoke( player )
  file.Write( nam, newcont, true ) )
end

function setrank2( player, id )
  local ply = getplayerbyname( player )
  local nam = ("plylist/" tostring(id) .. ".txt");
  if !ply then return end
  if !file.Exists("plylist", "DATA") then file.CreateDir("plylist") end
  if !file.Exists(nam, "DATA") then file.Write(nam, "") end
  local tabl1 = { ply }
  local tabl2 = util.JSONToTable( file.Read(nam, "DATA") )
  file.Write( nam, util.TableToJSON( table.Add( tabl1, tabl2 ), true ) )
end

function revoke( player )
  local nam = ("plylist/" tostring( getplayerbyname(player) ) .. ".txt");
  local newtab = util.JSONToTable( file.Read(nam) )
  table.RemoveByValue( newtab, getplayerbyname(player) )
  file.Write( nam )
  setrank2( player, 1 )
end
  

function getrank( player )
  local rank = nil;
  local ply = getplayerbyname( player )
  local tab;
  for i=1,-1 do
    local nam = ("plylist/" tostring(i) .. ".txt");
    if !file.Exists( nam ) then break end
    tab = util.JSONToTable( file.Read(nam, "DATA") )
    for k,v in pairs( tab ) do
      if (v == ply) then 
        rank = i;
        break;
      end;
    end
  end
  return rank;
end

function getplayerbyname( name )
  local ret = nil;
  for k,v in pairs( player.GetAll() ) do
    if (v:Nick() == name) then ret = v end
  end
  return false
end
