Class WMUpgrade_Skill_Tactician extends WMUpgrade_Skill;
	
var array<float> Mod;
	
static simulated function GetZedTimeModifier(out float InModifier, int upgLevel, KFWeapon KFW)
{
	local name StateName;
	StateName = KFW.GetStateName();
	
	if( StateName == 'Reloading' || StateName == 'AltReloading' || StateName == 'WeaponPuttingDown' || StateName == 'WeaponEquipping')
		InModifier += default.Mod[upgLevel-1];
}

defaultproperties
{
	upgradeName="Tactician"
	upgradeDescription(0)="During ZED Time, you reload and switch <font color=\"#eaeff7\">all weapons</font> at full speed"
	upgradeDescription(1)="During ZED Time, you reload and switch <font color=\"#eaeff7\">all weapons</font> <font color=\"#eaeff7\">faster than</font> full speed"
	Mod(0)=1.000000;
	Mod(1)=1.750000;
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Tactician'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Tactician_Deluxe'
}