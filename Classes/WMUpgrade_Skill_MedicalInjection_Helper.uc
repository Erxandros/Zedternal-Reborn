class WMUpgrade_Skill_MedicalInjection_Helper extends Info
	transient;

var KFPawn_Human Player;
var byte DeluxeLvl;
var const byte MinHealth, Regen;
var const array<float> MaxRegenDelay, MinRegenDelay;

function PostBeginPlay()
{
	super.PostBeginPlay();

	Player = KFPawn_Human(Owner);
	if (Player == None || Player.Health <= 0)
		Destroy();
}

function StartTimer(bool bDeluxe)
{
	if (bDeluxe)
		DeluxeLvl = 1;
	else
		DeluxeLvl = 0;

	SetTimer(MinRegenDelay[DeluxeLvl], False);
}

function Timer()
{
	if (Player == None || Player.Health <= 0)
	{
		Destroy();
		return;
	}

	if (Player.Health < MinHealth)
		Player.HealDamage(Regen, KFPlayerController(Player.Controller), class'KFDT_Healing', False, False);

	if (Player.Health < MinHealth)
		SetTimer(MinRegenDelay[DeluxeLvl] + Player.Health * (MaxRegenDelay[DeluxeLvl] - MinRegenDelay[DeluxeLvl]) / float(MinHealth), False);
	else
		SetTimer(MinRegenDelay[DeluxeLvl], False);
}

defaultproperties
{
	DeluxeLvl=0
	MinHealth=50
	Regen=1
	MaxRegenDelay(0)=1.5f
	MaxRegenDelay(1)=1.0f
	MinRegenDelay(0)=0.33f
	MinRegenDelay(1)=0.125f

	Name="Default__WMUpgrade_Skill_MedicalInjection_Helper"
}
