Class WMUpgrade_Skill_Fortitude_Regen extends Info
	transient;

var KFPawn_Human Player;
var int Regen;
var bool bDeluxe;

function PostBeginPlay()
{
	Player = KFPawn_Human(Owner);
	if(Player==none)
		Destroy();
	else
		SetTimer(2.f,false);
}
function Timer()
{
	if(Player==None || Player.Health<=0)
		Destroy();
	else if(Player.Health<Player.HealthMax )
		Player.Health = Min(Player.Health+default.Regen,Player.HealthMax);
	
	if (bDeluxe)
		SetTimer(1.f,false);
	else
		SetTimer(2.f,false);
}

defaultproperties
{
   Regen=1
   bDeluxe=false
   Name="Default__WMUpgrade_Skill_Fortitude_Regen"
}
