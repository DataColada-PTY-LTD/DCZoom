/*
    The MIT License
    Copyright © 2020 DataColada Pty Ltd

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
 */
public without sharing class SFZoom_CampaignMemberTriggerHandler {
    /******************************************************************************************************************
        Method Name : afterInsertHandler
        Description : After Insert event handler for the trigger
        Date        : 16 June 2021
        Author      : DataColada Pty Ltd
        *******************************************************************************************************************/
        public static void afterInsertHandler(List<CampaignMember> newRecordList){
            sendZoomMeetingInvites(newRecordList);
        }
    
        /******************************************************************************************************************
            Method Name : testInsertMeetingZoomEvent
            Description : Filter out the invites based on filter criteria.
            Date        : 16 June 2021
            Author      : DataColada Pty Ltd
            *******************************************************************************************************************/
        //@TestVisible
        private static void sendZoomMeetingInvites(List<CampaignMember> camMembersList){
            List<CampaignMember> camMembersListFiltered = new List<CampaignMember>();
            for(CampaignMember eachCamMem : camMembersList){
                if(eachCamMem.Status == 'Not Sent'){
                    camMembersListFiltered.add(eachCamMem);
                }
            }
            if(sendInvitations(camMembersListFiltered)){
                    markCampaignMembersAsSent(camMembersListFiltered);
            }
        }
    
        /******************************************************************************************************************
            Method Name : testInsertMeetingZoomEvent
            Description : Updates list of campaign members as Sent on status field.
            Date        : 16 June 2021
            Author      : DataColada Pty Ltd
            *******************************************************************************************************************/
        private static void markCampaignMembersAsSent(List<CampaignMember> camMembersList){
            List<CampaignMember> toBeUpdated = new List<CampaignMember>();
            for(CampaignMember eachMember : camMembersList){
                toBeUpdated.add(new CampaignMember(Id=eachMember.Id, Status='Sent'));
            }
            Update toBeUpdated;
        }
    
        /******************************************************************************************************************
            Method Name : sendInvitations
            Description : This method is extended to support send email for selected list of campaign members.
                                              Extended from SFZoom_MeetingHandlerExtension class.
            Date        : 16 June 2021
            Author      : DataColada Pty Ltd
            *******************************************************************************************************************/
        private static Boolean sendInvitations(List<CampaignMember> camMembersList){
            Boolean isSuccess = true;
            Map<Id, List<SFZoom_MeetingHandlerExtension.InviteeDetailsWrapper>> campaignToInviteDetails = new Map<Id, List<SFZoom_MeetingHandlerExtension.InviteeDetailsWrapper>>();
            List<Id> campaignIds = new List<Id>();
            Map<Id, List<Id>> campaignToMeetingIdsMap = new Map<Id, List<Id>>();
            Map<Id, List<Id>> campaignToCamMemIdsMap = new Map<Id, List<Id>>();
    
            for(CampaignMember eachCamMem : camMembersList){
                if(eachCamMem.campaignId!=null){
                    campaignIds.add(eachCamMem.campaignId);
                    if(!campaignToCamMemIdsMap.containsKey(eachCamMem.campaignId)){
                        campaignToCamMemIdsMap.put(eachCamMem.campaignId, new List<Id>{eachCamMem.Id});
                    }else{
                        campaignToCamMemIdsMap.get(eachCamMem.campaignId).add(eachCamMem.Id);
                    }
                }
            }
            if(!campaignIds.isEmpty()){
                DateTime currentDateTime = System.now();
                for(Campaign eachCam : [SELECT (SELECT Id FROM Zoom_Meetings__r WHERE Auto_Send_Email_Invite__c=true AND Start_Date_Time__c >=:currentDateTime) FROM Campaign WHERE Id =: campaignIds LIMIT : (Limits.getLimitQueryRows()-Limits.getQueryRows())]){
                    if(eachCam.Zoom_Meetings__r!=null && !eachCam.Zoom_Meetings__r.isEmpty()){
                        if(!campaignToMeetingIdsMap.containsKey(eachCam.Id)){
                            campaignToMeetingIdsMap.put(eachCam.Id, new List<Id>());
                        }
                        for(Zoom_Meeting__c eachMeeting : eachCam.Zoom_Meetings__r){
                            campaignToMeetingIdsMap.get(eachCam.Id).add(eachMeeting.Id);
                        }
                    }
                }
    
                campaignToInviteDetails = SFZoom_MeetingHandlerExtension.FindListOfContactOrLeadFromChildRecords(campaignToCamMemIdsMap);
    
                if(campaignToInviteDetails!=null && !campaignToInviteDetails.isEmpty()){
                    //For Every Campaign in Trigger Context
                    for(Id campId : campaignToMeetingIdsMap.keySet()){
                        if(campaignToInviteDetails.containsKey(campId) && !campaignToInviteDetails.get(campId).isEmpty()){
                            //For Every Zoom Meeting linked to Campaign in Trigger Context
                            //SendEmailInviteLightning method is being called within nested loop because it doesn't support bulkification.
                            for(Id meetingId : campaignToMeetingIdsMap.get(campId)){
                                SFZoom_MeetingHandlerExtension SFZoomMeetingHandlerInstance = new SFZoom_MeetingHandlerExtension(meetingId, campId, true);
                                SFZoomMeetingHandlerInstance.listOfNotInvitedRecordDetails = campaignToInviteDetails.get(campId);
                                String errorMsg = SFZoomMeetingHandlerInstance.SendEmailInviteLightning(false);
    
                                if(String.isNotBlank(errorMsg)){
                                    isSuccess = false;
                                    System.debug('Error => '+errorMsg);
                                }
                            }
                        }
                    }
                }
            }
            return isSuccess;
        }    
}