concommand.Add( "rlib_set", function( ply, cmd, args ) -- rlib_set <playername> <id>
  if !IsValid( args[2] ) then print("Not enough arguments!") return end
  net.Start("rlib_set")
  net.WriteString( args[1] )
  net.WriteInt( util.StringToType( args[2], "int" ) )
  net.SendToServer()
end )
