class WMUpgrade_Skill_AssaultArmor_Counter extends Info
	transient;

var WMPawn_Human Player;

replication
{
	if ( bNetOwner )
		Player;
}

function PostBeginPlay()
{
	super.PostBeginPlay();

	Player = WMPawn_Human(Owner);
	if (Player == None || Player.Health <= 0)
		Destroy();
}

function GiveArmor(float Armor)
{
	Player.ZedternalArmor = Min(Player.ZedternalArmor + Round(Armor * Player.GetMaxArmor()), Player.GetMaxArmor());
	SetClientArmor(Player.ZedternalArmor);
}

reliable client function SetClientArmor(int Armor)
{
	Player.ZedternalArmor = Armor;
}

defaultproperties
{
	Name="Default__WMUpgrade_Skill_AssaultArmor_Counter"
}
