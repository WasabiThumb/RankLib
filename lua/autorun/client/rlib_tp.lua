local tprsubject;
local istorequester = false;

net.Receive( "tpr_receive", function()
    tprsubject = net.ReadEntity()
    istorequester = net.ReadBool()
end )

net.Receive( "tpra", function()
    if tpsubject:IsValid() and !istorequester then
      LocalPlayer():SetPos( tprsubject:GetPos() )
    else if tpsubject:IsValid() and istorequester then
      tprsubject:SetPos( LocalPlayer():GetPos() )
    else
      chat.AddText( "Player is offline!" )
    end
end )
