class WMUpgrade_Skill_MedicalInjection_Helper extends Info
	transient;

var KFPawn_Human Player;
var bool bDeluxe;
var int Regen, MinHealth;
var array<float> MinRegenDelay, MaxRegenDelay;

function PostBeginPlay()
{
	super.PostBeginPlay();

	Player = KFPawn_Human(Owner);
	if (Player == None || Player.Health <= 0)
		Destroy();
	else
		SetTimer(1.0f, False);
}

function Timer()
{
	local byte lvl;

	if (Player == None || Player.Health <= 0)
	{
		Destroy();
		return;
	}

	if (Player.Health < default.MinHealth)
		Player.HealDamage(default.Regen, KFPlayerController(Player.Controller), class'KFDT_Healing', False, False);

	if (bDeluxe)
		lvl = 1;
	else
		lvl = 0;

	if (Player.Health < default.MinHealth)
		SetTimer(default.MinRegenDelay[lvl] + Player.Health * (default.MaxRegenDelay[lvl] - default.MinRegenDelay[lvl]) / default.MinHealth, False);
	else
		SetTimer(default.MinRegenDelay[lvl], False);
}

defaultproperties
{
	bDeluxe=False
	Regen=1
	MinHealth=50
	MinRegenDelay(0)=0.33f
	MinRegenDelay(1)=0.125f
	MaxRegenDelay(0)=1.5f
	MaxRegenDelay(1)=1.0f

	Name="Default__WMUpgrade_Skill_MedicalInjection_Helper"
}
