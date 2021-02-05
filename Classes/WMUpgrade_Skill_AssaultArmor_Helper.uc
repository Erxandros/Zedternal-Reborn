class WMUpgrade_Skill_AssaultArmor_Helper extends Info
	transient;

var WMPawn_Human Player;

function PostBeginPlay()
{
	super.PostBeginPlay();

	Player = WMPawn_Human(Owner);
	if (Player == None || Player.Health <= 0)
		Destroy();
}

function GiveArmor(float Armor)
{
	Player.AddArmor(Round(Armor * Player.GetMaxArmor()));
}

defaultproperties
{
	Name="Default__WMUpgrade_Skill_AssaultArmor_Helper"
}
