class WMUpgrade_Equipment_GasMask extends WMUpgrade_Equipment;

static simulated function GetPerkLensEffect(out class<EmitterCameraLensEffectBase> CamEffect, class<KFDamageType> DmgType, int upgLevel)
{
	if (ClassIsChildOf(DmgType, class'KFDT_Toxic'))
		CamEffect = None;
}

defaultproperties
{
	upgradeName="Gas Mask"
	upgradeDescription(0)="Prevents toxic effects from blocking your vision"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Equipment.UI_Equipment_GasMask'

	Name="Default__WMUpgrade_Equipment_GasMask"
}
