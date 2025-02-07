trigger SFZoom_CampaignMemberTrigger on CampaignMember (after insert) {
    if(Trigger.isInsert && Trigger.isAfter){
        SFZoom_CampaignMemberTriggerHandler.afterInsertHandler(Trigger.new);
    }
}