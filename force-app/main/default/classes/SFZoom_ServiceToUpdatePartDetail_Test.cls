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

/******************************************************************************************************************
    Class Name  : SFZoomServiceToUpdatePrcipntsDetail_Test
    Description : This class is responsible for testing the webhook response and the meeting attandance Tracking.
    Date        : 05 Dec 2018.
    Author       : DataColada Pty Ltd
*******************************************************************************************************************/
@isTest(seeAllData = false)
public class SFZoom_ServiceToUpdatePartDetail_Test {

/*******************************************************************************************************************
        Method Name  : testUpdateMeetingParticipantDetails
        Description  : It verifies update meeting participants detail operation after receiving the webhook response.
        Date         : 05 Dec 2018.
        Author       : DataColada Pty Ltd
********************************************************************************************************************/
    @isTest
    static void testUpdateMeetingParticipantDetails(){
        SFZoom_MeetingHandlerExtension_Test.InsertDefaultConfigSetting();
        Zoom_Configuration_Settings__c zoomConfigurationDetailsInserted = Zoom_Configuration_Settings__c.getValues('Zoom Settings');
        System.assertNotEquals(null, zoomConfigurationDetailsInserted);
        Lead testLead = new Lead(FirstName = 'Test', LastName = 'Weebles Lead Test', Company ='Weebles Widgets', Email='testlead@mailinator.com');
        INSERT testLead;
        Contact testContact = new Contact(FirstName = 'Test', LastName = 'Weebles Lead Test', Email='testlead@mailinator.com');
        insert testContact;
        Campaign campaignInserted = SFZoom_MeetingHandlerExtension_Test.InsertCampaignWithCampaignMembers(testLead.Id);
        System.assertNotEquals(null, campaignInserted.Id);
        Zoom_Meeting__c zoomMeetingCreated = SFZoom_MeetingHandlerExtension_Test.createZoomMeeting();
        System.assertNotEquals(null, zoomMeetingCreated.Id);
        zoomMeetingCreated.Campaign__c = campaignInserted.Id;
        zoomMeetingCreated.Thank_you_notification__c = true;
        zoomMeetingCreated.Share_Survey_Link__c = true;
        zoomMeetingCreated.Share_Recording_URL__c = true;
        zoomMeetingCreated.Survey_Link_URL__c = 'https://www.testsurvey.com';
        zoomMeetingCreated.Meeting_Recording_URL__c = 'https://www.myrecording.com';
        UPDATE zoomMeetingCreated;

        Event eventCreated = SFZoom_MeetingHandlerExtension_Test.CreateEvent(zoomMeetingCreated.Id, testContact.Id,campaignInserted.Id);
        System.assertNotEquals(null, eventCreated.Id);
        ApexPages.currentPage().getParameters().put('retURL','/'+campaignInserted.Id);
        Test.setMock(HttpCalloutMock.class, new SFZoom_LightningEventHandler_CalloutMock(true,false));
        SFZoom_MeetingHandlerExtension meetinghandlerExtensionTest = new SFZoom_MeetingHandlerExtension(
        new ApexPages.StandardController(new Zoom_Meeting__c(Id=zoomMeetingCreated.Id,
                                                                         Campaign__c = zoomMeetingCreated.Campaign__c,
                                                                         RecordTypeId = zoomMeetingCreated.RecordTypeId)));

        String testResponse = '{"uuid":"sojydbtWQSuPOOA/VEcDGA==","id":998995105,"account_id":"0o9aggZHT02Bxxb2h1MW4Q","host_id":"Qi79NR8_TXqkvj4uV5GBzg","topic":"zoom meeting wed","type":2,"start_time":"2019-03-11T11:45:29Z","timezone":"Australia/Sydney","duration":1,"total_size":285719,"recording_count":2,"share_url":"https://api.test.com"}';
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/UpdateMeetingParticipantsDetail';
        req.httpMethod = 'POST';
        String contentToParse = '{"payload":{"account_id":"0o9aggZHT02Bxxb2h1MW4Q","meeting":{"duration":60,"status":"ENDED","start_time":"2018-09-06T14:11:02Z","timezone":"Asia/Calcutta","end_time":"","topic":"Meeting","id":"661257541","uuid":"QY/MSvURSiGOjrfRs/hEBg==","host_id":"Qi79NR8_TXqkvj4uV5GBzg"}},"event":"meeting_ended"}';
        req.requestBody = Blob.valueof(contentToParse);
        RestContext.request = req;
        RestContext.response= res;

                 List<Event> lisOfEvents = [SELECT ID, Zoom_Meeting_Attendance__c FROM Event where Zoom_Meeting__c = :zoomMeetingCreated.Id];
            for(Event eventVar : lisOfEvents){
                eventVar.Zoom_Meeting_Attendance__c = Label.Meeting_Attended_Value;
            }
        UPDATE lisOfEvents;

        SFZoom_ServiceToUpdateParticipantsDetail.UpdateMeetingParticipantDetails();
        SFZoom_ServiceToUpdateParticipantsDetail.FindRecordingPlayUrl(testResponse);
        Test.stopTest();
        List<Zoom_Meeting__c> listOfZoomMeeting = [SELECT Webhook_Response__c FROM Zoom_Meeting__c
                                                           WHERE Name = '661257541' LIMIT 1];
        System.assertEquals(contentToParse, listOfZoomMeeting[0].Webhook_Response__c);

    }

    /*******************************************************************************************************************
        Method Name  : testUpdateMeetingParticipantDetails
        Description  : It verifies update meeting participants detail operation after receiving the webhook response.
        Date         : 30 Apr 2019.
        Author       : DataColada Pty Ltd
********************************************************************************************************************/
    @isTest
    static void testUpdateMeetingParticipantDetails_Cancellation(){
        SFZoom_MeetingHandlerExtension_Test.InsertDefaultConfigSetting();
        Zoom_Configuration_Settings__c zoomConfigurationDetailsInserted = Zoom_Configuration_Settings__c.getValues('Zoom Settings');
        System.assertNotEquals(null, zoomConfigurationDetailsInserted);
        Lead testLead = new Lead(FirstName = 'Test', LastName = 'Weebles Lead Test', Company ='Weebles Widgets', Email='testlead@mailinator.com');
        INSERT testLead;
        Campaign campaignInserted = SFZoom_MeetingHandlerExtension_Test.InsertCampaignWithCampaignMembers(testLead.Id);
        System.assertNotEquals(null, campaignInserted.Id);
        Zoom_Meeting__c zoomMeetingCreated = SFZoom_MeetingHandlerExtension_Test.createZoomMeeting();
        System.assertNotEquals(null, zoomMeetingCreated.Id);
        zoomMeetingCreated.Campaign__c = campaignInserted.Id;
        zoomMeetingCreated.Thank_you_notification__c = true;
        zoomMeetingCreated.Share_Survey_Link__c = true;
        zoomMeetingCreated.Share_Recording_URL__c = true;
        zoomMeetingCreated.Survey_Link_URL__c = 'https://www.testsurvey.com';
        zoomMeetingCreated.Meeting_Recording_URL__c = 'https://www.myrecording.com';
        UPDATE zoomMeetingCreated;

        Event eventCreated = SFZoom_MeetingHandlerExtension_Test.CreateEvent(zoomMeetingCreated.Id, testLead.Id,null);
        System.assertNotEquals(null, eventCreated.Id);
        eventCreated.Zoom_Registration_Id__c = 'zBEzSk_NQgi3go7jsPm-fw';
        UPDATE eventCreated;
        ApexPages.currentPage().getParameters().put('retURL','/'+campaignInserted.Id);
        Test.setMock(HttpCalloutMock.class, new SFZoom_LightningEventHandler_CalloutMock(true,false));
        SFZoom_MeetingHandlerExtension meetinghandlerExtensionTest = new SFZoom_MeetingHandlerExtension(
        new ApexPages.StandardController(new Zoom_Meeting__c(Id=zoomMeetingCreated.Id,
                                                                         Campaign__c = zoomMeetingCreated.Campaign__c,
                                                                         RecordTypeId = zoomMeetingCreated.RecordTypeId)));
        String testResponse = '{"uuid":"sojydbtWQSuPOOA/VEcDGA==","id":998995105,"account_id":"0o9aggZHT02Bxxb2h1MW4Q","host_id":"Qi79NR8_TXqkvj4uV5GBzg","topic":"zoom meeting wed","type":2,"start_time":"2019-03-11T11:45:29Z","timezone":"Australia/Sydney","duration":1,"total_size":285719,"recording_count":2,"share_url":"https://api.test.com"}';
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/UpdateMeetingParticipantsDetail';
        req.httpMethod = 'POST';

        String contentToParse = '{"event": "meeting.registration_cancelled","payload":{"account_id": "0o9aggZHT02Bxxb2h1MW4Q","operator": "apurva.ghatge7@gmail.com","object":{"uuid": "UGv3SZYXSxO2AfkmJozgsA==","id": 607248205,"host_id": "Qi79NR8_TXqkvj4uV5GBzg","topic": "test 1","type": 2,"start_time": "2019-04-24T15:30:00Z","duration": 35,"timezone": "Australia/Sydney","registrant":{"id": "zBEzSk_NQgi3go7jsPm-fw","first_name": "Test Demo","last_name": "Lead","email": "apurva.ghatge7@gmail.com"}}}}';
        req.requestBody = Blob.valueof(contentToParse);
        RestContext.request = req;
        RestContext.response= res;

         List<Event> lisOfEvents = [SELECT ID, Zoom_Meeting_Attendance__c FROM Event where Zoom_Meeting__c = :zoomMeetingCreated.Id];
            for(Event eventVar : lisOfEvents){
                //eventVar.Zoom_Meeting_Attendance__c = Label.Meeting_Attended_Value;
                eventVar.Zoom_Meeting_Attendance__c = Label.Meeting_Cancelled_Value;
            }
        UPDATE lisOfEvents;
        SFZoom_ServiceToUpdateParticipantsDetail.UpdateMeetingParticipantDetails();

        Test.stopTest();
    }

   /*******************************************************************************************************************
        Method Name  : zoomWebHookValidation
        Description  : It verifies Zoom Web Hook Validation operation after receiving the webhook response.
        Date         : 27 sept 2024.
        Author       : DataColada Pty Ltd
********************************************************************************************************************/

        @TestSetup
    static void setupTestData() {
        // Create Zoom Configuration Settings
        Zoom_Configuration_Settings__c zoomSettings = new Zoom_Configuration_Settings__c(
            Name = 'Zoom Settings',
            Zoom_Webhook_Secret_Token__c = 'mySecretToken'
        );
        insert zoomSettings;
    }

    @IsTest
    static void testZoomWebHookValidation() {
        // Set up a mock RestRequest with the necessary payload
        RestRequest req = new RestRequest();
        req.requestBody = Blob.valueOf('{ "payload": { "plainToken": "testToken" } }');
        req.httpMethod = 'POST';

        // Prepare the RestResponse
        RestResponse res = new RestResponse();

        // Call the method
        Test.startTest();
        SFZoom_ServiceToUpdateParticipantsDetail.zoomWebHookValidation(req, res);
        Test.stopTest();

        // Query Zoom Settings
        Zoom_Configuration_Settings__c zoomSettings = Zoom_Configuration_Settings__c.getValues('Zoom Settings');

        // Expected signature calculation
        Blob signature = Crypto.generateMac('hmacSHA256', Blob.valueOf('testToken'), Blob.valueOf(zoomSettings.Zoom_Webhook_Secret_Token__c));
        String expectedHashForValidate = EncodingUtil.convertToHex(signature);

        // Parse the response body
        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(res.responseBody.toString());

        // Assertions
        System.assertEquals(200, res.statusCode);
        System.assertEquals('testToken', responseMap.get('plainToken'));
        System.assertEquals(expectedHashForValidate, responseMap.get('encryptedToken'));
    }

 /******************************************************************************************************************
        Method Name  : InsertDefaultConfigSetting
        Description  : It inserts default custom setting for the zoom account configuration
        Date         : 01 Oct 2024.
        Author       : DataColada Pty Ltd
    *******************************************************************************************************************/

   @isTest
    static void testFindListOfContactOrLeadFromChildRecords() {
    // Step 1: Create test data for parent Account

    Account parentAccount = new Account(Name = 'Test Account');
    insert parentAccount;

    // Create child Contacts linked to the parent Account
    Contact contact1 = new Contact(FirstName = 'John', LastName = 'Doe', AccountId = parentAccount.Id);
    Contact contact2 = new Contact(FirstName = 'Jane', LastName = 'Doe', AccountId = parentAccount.Id);
    insert new List<Contact>{ contact1, contact2 };

    // Create Leads
    Lead lead1 = new Lead(FirstName = 'Lead', LastName = 'One', Company = 'Company A');
    Lead lead2 = new Lead(FirstName = 'Lead', LastName = 'Two', Company = 'Company B');
    insert new List<Lead>{ lead1, lead2 };

    // Step 2: Create a map of parent Account to child Contact and Lead IDs
    Map<Id, List<Id>> parentToChildRecordIds = new Map<Id, List<Id>>();
    parentToChildRecordIds.put(parentAccount.Id, new List<Id>{ contact1.Id, contact2.Id, lead1.Id, lead2.Id });

    // Step 3: Test execution using startTest and stopTest
    Test.startTest();

    // Invoke the method being tested
    Map<Id, List<Object>> result = SFZoom_MeetingHandlerExtension.FindListOfContactOrLeadFromChildRecords(parentToChildRecordIds);

    Test.stopTest();

    // Step 4: Perform assertions
    // Check that the result map is not null
    System.assert(result != null, 'Result should not be null');

    // Verify that the map contains the parent account
    System.assertEquals(1, result.size(), 'Result map should contain 1 parent account');

    // Verify the number of records in the list for the parent account
    List<Object> inviteeDetails = result.get(parentAccount.Id);
        }

 /******************************************************************************************************************
        Method Name  : testGetMapChildandWho
        Description  : It effect SFZoomServiceToUpdatePrcipntsDetail to test Get Map Child and Who
        Date         : 01 Oct 2024.
        Author       : DataColada Pty Ltd
    *******************************************************************************************************************/
    @isTest
    static void testGetMapChildandWho() {
        // Step 1: Create mock child records (replace with actual child SObject type, e.g., Contact or Lead)
        List<SObject> lstChildRecords = new List<SObject>();

        Contact childRecord = new Contact(FirstName = 'John', LastName = 'Doe');
         insert childRecord;
        lstChildRecords.add(childRecord);

        // Step 2: Create a mock Zoom_Metadata__mdt record
        Zoom_Metadata__mdt currentZoomSetting = [SELECT Id, Contact_Lookup_Field__c ,Attendance_Status_Field_Api_Name__c,
                                                                                 Email_Field_API_Name_of_Contact__c, Child_Relationship_Name__c, Child_Object_API_Name__c,
                                                                                 Lead_Lookup_Field__c, Parent_Object_Name__c, Lookup_Field_API_Name__c,
                                                                                 Email_Field_API_Name_of_Lead__c
                                                 FROM Zoom_Metadata__mdt
                                                 WHERE DeveloperName = 'Account_Meeting_Setting'
                                                 LIMIT 1];

        // Step 3: Call the method
        Map<String, String> result = SFZoom_ServiceToUpdateParticipantsDetail.getMapChildandWho(lstChildRecords, currentZoomSetting);

        // Step 4: Validate the result
        System.assertNotEquals(null, result, 'The result map should not be null.');
        System.assertEquals(1, result.size(), 'The result map should contain one entry.');
    }

}
