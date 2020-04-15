Class WMUpgrade_Skill_MedicalInjection_Regen extends Info
	transient;

var KFPawn_Human Player;
var int Regen, minHealth;
var array<float> minRegenDelay, maxRegenDelay;
var bool bDeluxe;

function PostBeginPlay()
{
	Player = KFPawn_Human(Owner);
	if(Player==none || Player.Health<=0)
		Destroy();
	else
		SetTimer(1.f, false);
}
function Timer()
{
	local byte lvl;
	
	if(Player==None || Player.Health<=0)
		Destroy();
	else if(Player.Health < minHealth )
		Player.HealDamage( Regen, KFPlayerController(Player.Controller), class'KFDT_Healing', false, false );
	
	if (bDeluxe)
		lvl = 1;
	else
		lvl = 0;
	
	if (Player.Health < default.minHealth)
		SetTimer(default.minRegenDelay[lvl] + Player.Health * (default.maxRegenDelay[lvl] - default.minRegenDelay[lvl]) / default.minHealth, false);
	else
		SetTimer(default.minRegenDelay[lvl], false);
}

defaultproperties
{
   Regen=1
   minRegenDelay(0)=0.333333
   minRegenDelay(1)=0.125000
   maxRegenDelay(0)=1.500000
   maxRegenDelay(1)=1.000000
   minHealth=50
   bDeluxe=false
   Name="Default__WMUpgrade_Skill_MedicalInjection_Regen"
}
