class WMUpgrade_Skill_HeatWaves extends WMUpgrade_Skill;

var float Stumble;
var array<int> RadiusSQ;

static function ModifyStumblePower(out float InStumblePower, float DefaultStumblePower, int upgLevel, optional KFPawn KFP, optional class<KFDamageType> DamageType, optional out float CooldownModifier, optional byte BodyPart, optional KFPawn OwnerPawn)
{
	if (OwnerPawn != None && KFP != None && VSizeSQ(OwnerPawn.Location - KFP.Location) <= default.RadiusSQ[upgLevel - 1])
		InStumblePower += DefaultStumblePower * default.Stumble;
}

static simulated function bool IsGroundFireActive(int upgLevel, KFPawn OwnerPawn)
{
	return True;
}

defaultproperties
{
	Stumble=3.0f
	RadiusSQ(0)=70000
	RadiusSQ(1)=280000

	upgradeName="Heat Waves"
	upgradeDescription(0)="Greatly increase stumble effect at point blank range with <font color=\"#eaeff7\">all weapons</font>. Increase <font color=\"#caab05\">ground fire</font> damage"
	upgradeDescription(1)="Greatly increase stumble effect at <font color=\"#b346ea\">short and medium ranges</font> with <font color=\"#eaeff7\">all weapons</font>. Increase <font color=\"#caab05\">ground fire</font> damage"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_HeatWaves'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_HeatWaves_Deluxe'

	Name="Default__WMUpgrade_Skill_HeatWaves"
}
