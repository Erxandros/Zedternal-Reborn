class WMUpgrade_Skill_Tactician extends WMUpgrade_Skill;

var array<float> Mod;

static simulated function GetZedTimeModifier(out float InModifier, int upgLevel, KFWeapon KFW)
{
	local name StateName;
	StateName = KFW.GetStateName();

	if (StateName == 'Reloading' || StateName == 'AltReloading' || StateName == 'WeaponPuttingDown' || StateName == 'WeaponEquipping')
		InModifier += default.Mod[upgLevel - 1];
}

defaultproperties
{
	Mod(0)=1.0f
	Mod(1)=1.75f

	upgradeName="Tactician"
	upgradeDescription(0)="During ZED Time, you reload and switch <font color=\"#eaeff7\">all weapons</font> at full speed"
	upgradeDescription(1)="During ZED Time, you reload and switch <font color=\"#eaeff7\">all weapons</font> <font color=\"#b346ea\">75%</font> faster than full speed"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Tactician'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Tactician_Deluxe'

	Name="Default__WMUpgrade_Skill_Tactician"
}
