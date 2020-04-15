Class WMUpgrade_Skill_Vampire extends WMUpgrade_Skill;

var array<int> meleeVampire, weapVampire;

static function AddVampireHealth( out int InHealth, int DefaultHealth, int upgLevel, KFPlayerController KFPC, class<DamageType> DT )
{
	if (class<KFDamageType>(DT) != none && static.IsMeleeDamageType(DT))
		InHealth += default.meleeVampire[upgLevel-1];
	else
		InHealth += default.weapVampire[upgLevel-1];
}

defaultproperties
{
	upgradeName="Vampire"
	upgradeDescription(0)="Heal <font color=\"#eaeff7\">2</font> or <font color=\"#caab05\">3</font> points of Health whenever you kill a Zed with <font color=\"#eaeff7\">any weapons</font> or with <font color=\"#caab05\">any melee weapons</font>"
	upgradeDescription(1)="Heal <font color=\"#b346ea\">5</font> or <font color=\"#b346ea\">8</font> points of Health whenever you kill a Zed with <font color=\"#eaeff7\">any weapons</font> or with <font color=\"#caab05\">any melee weapons</font>"
	meleeVampire(0)=3
	meleeVampire(1)=8
	weapVampire(0)=2
	weapVampire(1)=5
	upgradeIcon(0)=Texture2D'Zedternal_Resource.Skills.UI_Skill_Vampire'
	upgradeIcon(1)=Texture2D'Zedternal_Resource.Skills.UI_Skill_Vampire_Deluxe'
}