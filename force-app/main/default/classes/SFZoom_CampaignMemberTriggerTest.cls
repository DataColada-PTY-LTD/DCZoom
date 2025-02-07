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
@isTest
public with sharing class SFZoom_CampaignMemberTriggerTest {
    @isTest
    static void triggerTest(){
        InsertDefaultConfigSetting();
        Zoom_Configuration_Settings__c zoomConfigurationDetailsInserted = Zoom_Configuration_Settings__c.getValues('Zoom Settings');
        System.assertNotEquals(null, zoomConfigurationDetailsInserted);
        Contact testContact = new Contact(LastName = 'Test Weebles Contact', Email='Test@test.com');
        INSERT testContact;
        System.assertNotEquals(null, testContact.Id);
        Campaign campaignToTest = InsertCampaignWithCampaignMembersOfContact(testContact.Id);
        System.assertNotEquals(null, campaignToTest.Id);

        Test.startTest();
        ApexPages.currentPage().getParameters().put('retURL','/'+campaignToTest.Id);

        SFZoom_MeetingHandlerExtension meetinghandlerExtensionTest = new SFZoom_MeetingHandlerExtension(new ApexPages.StandardController(campaignToTest));
        meetinghandlerExtensionTest.zoomMeeting.Topic__c = 'Test Meeting Topic';
        meetinghandlerExtensionTest.zoomMeeting.Agenda__c = 'Test Meeting Agenda';
        meetinghandlerExtensionTest.zoomMeeting.Start_Date__c = System.today().addDays(12);
        meetinghandlerExtensionTest.meetingStartTime = null;
        meetinghandlerExtensionTest.eventType='Webinar';
        meetinghandlerExtensionTest.CreateWebinar();
        ApexPages.Message[] pageMessages = ApexPages.getMessages();
        System.assertNotEquals(0, pageMessages.size());
        meetinghandlerExtensionTest.meetingStartTime = Time.newInstance(18, 30, 2, 20);
        meetinghandlerExtensionTest.zoomMeeting.Duration__c = 1;

        pageMessages = ApexPages.getMessages();
        System.assertNotEquals(0, pageMessages.size());
        meetinghandlerExtensionTest.zoomMeeting.Duration__c = 30;
        meetinghandlerExtensionTest.zoomMeeting.Topic__c = 'Test Meeting Topic';
        meetinghandlerExtensionTest.zoomMeeting.Join_before_Host__c = false;
        meetinghandlerExtensionTest.zoomMeeting.Start_Participant_Video_on_Meeting_Join__c = true;
        meetinghandlerExtensionTest.zoomMeeting.Enforce_Login__c = true;
        meetinghandlerExtensionTest.zoomMeeting.Start_Date__c = System.today().addDays(12);
        meetinghandlerExtensionTest.zoomMeeting.Auto_Register__c = FALSE;
        Test.setMock(HttpCalloutMock.class, new SFZoom_LightningEventHandler_CalloutMock(true,false));
        PageReference meetingRef = meetinghandlerExtensionTest.CreateWebinar();
        system.assertEquals(null,meetingRef);
        for (SFZoom_MeetingHandlerExtension.InviteeDetailsWrapper inviteeDetails : meetinghandlerExtensionTest.listOfNotInvitedRecordDetails) {
            inviteeDetails.isSelected = false;
        }
        meetinghandlerExtensionTest.SendEmailInviteClassic();
        System.assertNotEquals(0, ApexPages.getMessages().size());
        meetinghandlerExtensionTest.SelectAllInvitees();
        for (SFZoom_MeetingHandlerExtension.InviteeDetailsWrapper inviteeDetails : meetinghandlerExtensionTest.listOfNotInvitedRecordDetails) {
            System.assertEquals(true, inviteeDetails.isSelected);
        }
        meetinghandlerExtensionTest.SelectAllInvitees();
        PageReference meetinfInviteCl = meetinghandlerExtensionTest.SendEmailInviteClassic();
        Test.stopTest();

        System.assertEquals(meetinfInviteCl.getURL(), ApexPages.currentPage().getParameters().get('retURL'));
        List<Zoom_Meeting__c> listOfCreatedZoomMeetings = [SELECT Duration__c FROM Zoom_Meeting__c];
        System.assertEquals(2, listOfCreatedZoomMeetings.size());
        System.assertEquals(30, listOfCreatedZoomMeetings[0].Duration__c);
    }

    /******************************************************************************************************************
Method Name  : InsertCampaignWithCampaignMembersOfContact
Description  : It creates test record for contact, campaign and campaign member.
Date         : 05 Dec 2018.
Author       : DataColada Pty Ltd
*******************************************************************************************************************/
    public static Campaign InsertCampaignWithCampaignMembersOfContact(Id contactId){
        //Create a campaign
        Campaign testCampaign = new Campaign(Name = 'Test Campaign 1', IsActive = True);
        INSERT testCampaign;
        createZoomMeetingForCampaign(testCampaign.id);
        INSERT new CampaignMemberStatus(Label='Not Sent', CampaignId=testCampaign.id);
        List<CampaignMember> listOfCmpMembers = new List<CampaignMember>();
        listOfCmpMembers.add(new CampaignMember(Status = 'Not Sent', ContactId = contactId, CampaignId = testCampaign.Id));
        INSERT listOfCmpMembers;

        return testCampaign;
    }

    public static void createZoomMeetingForCampaign(Id camId){
        Zoom_Meeting__c zoomMeeting = new Zoom_Meeting__c();
        List<RecordType> listOfRecordTypes = [SELECT Name FROM RecordType WHERE sObjectType = 'Zoom_Meeting__c'
                            AND DeveloperName = :Label.Meeting_Record_Type_Name LIMIT 1];
        zoomMeeting.Name = '661257541';
        zoomMeeting.Agenda__c = 'Test Meeting Agenda';
        zoomMeeting.Start_Date__c = System.today();
        zoomMeeting.Start_Time__c = Time.newInstance(18, 30, 2, 20);
        zoomMeeting.Duration__c = 30;
        zoomMeeting.Topic__c = 'Test Meeting Topic';
        zoomMeeting.Join_before_Host__c = false;
        zoomMeeting.Start_Participant_Video_on_Meeting_Join__c = true;
        zoomMeeting.Enforce_Login__c = true;
        zoomMeeting.Campaign__c = camId;
        zoomMeeting.Auto_Send_Email_Invite__c = true;
        if(!listOfRecordTypes.isEmpty()){
            zoomMeeting.RecordTypeId =  listOfRecordTypes[0].Id;
        }
        INSERT zoomMeeting;
    }

    /******************************************************************************************************************
Method Name  : InsertDefaultConfigSetting
Description  : It inserts default custom setting for the zoom account configuration
Date         : 01 Nov 2018.
Author       : DataColada Pty Ltd
*******************************************************************************************************************/
    public static void InsertDefaultConfigSetting(){
        Zoom_Configuration_Settings__c zoomConfigurationDetails = new Zoom_Configuration_Settings__c();
        zoomConfigurationDetails.Name = 'Zoom Settings';
        zoomConfigurationDetails.Zoom_API_Key__c = 'Test_API_Key';
        zoomConfigurationDetails.Zoom_API_Secret__c = 'Test_API_Secret';
        zoomConfigurationDetails.Zoom_URL__c = 'https://zoom.us/j/';
        zoomConfigurationDetails.Site_URL__c = 'https://datacoladasfzoom-developer-edition.ap5.force.com/';
        zoomConfigurationDetails.Email_Sender_Name__c = 'DataColada';
        zoomConfigurationDetails.Zoom_Authorization_Token__c = 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJxdk5YRzJmMVJXU1';
        zoomConfigurationDetails.Zoom_Account_User_Id__c = 'Qi79NR8_TXrqVJ2sK3uiyt';
        zoomConfigurationDetails.Enforce_Login__c = true;
        zoomConfigurationDetails.Join_Before_Host__c = true;
        zoomConfigurationDetails.Start_Participant_Video_on_Join__c = true;
        zoomConfigurationDetails.Send_Thank_you_email_notification__c = true;
        zoomConfigurationDetails.Share_Recording_URL__c = true;
        zoomConfigurationDetails.Share_Survey_Link__c = true;

        INSERT zoomConfigurationDetails;
        system.assertNotEquals(null, zoomConfigurationDetails);
    }
    
}