<aura:application access="GLOBAL" extends="ltng:outApp"
    implements="ltng:allowGuestAccess,force:appHostable,flexipage:availableForAllPageTypes">
    <aura:dependency resource="c:wbb_votenow" />
    <aura:dependency resource="markup://force:showToast" type="EVENT"/>
</aura:application>