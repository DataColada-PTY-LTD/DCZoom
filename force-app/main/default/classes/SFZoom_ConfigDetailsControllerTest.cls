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
    Class Name  : SFZoom_ConfigDetailsControllerTest
    Description : This class is responsible for testing all the operation of SFZoom_ConfigDetailsController Class.
    Date        : 01 Nov 2018.
    Author       : DataColada Pty Ltd
*******************************************************************************************************************/
@isTest(seeAllData = false)
public class SFZoom_ConfigDetailsControllerTest {

    /******************************************************************************************************************
        Method Name  : TestConfigDetailsControllerSaveAndEdit
        Description  : It verifies save and edit operation of the Zoom Configuration page.
        Date         : 01 Nov 2018.
        Author       : DataColada Pty Ltd
    *******************************************************************************************************************/
    @isTest
    static void TestConfigDetailsControllerSaveAndEdit(){
        Test.startTest();

        SFZoom_ConfigDetailsController controllerVar = new SFZoom_ConfigDetailsController();
        Test.setMock(HttpCalloutMock.class, new SFZoom_VerifyAuthAndSaveCalloutMock());


        System.assertEquals(false, controllerVar.isUpdate);
        System.assertEquals(false, controllerVar.isRecordExist);

        controllerVar.zoomAPIKey = 'Test_API_Key';
        controllerVar.ZoomAPISecret = 'Test_API_Secret';
        controllerVar.ZoomUserEmail = 'admin@datacolada.com';
        controllerVar.ZoomURL = 'https://zoom.us/j/';
        controllerVar.siteURL = 'https://datacoladasfzoom-developer-edition.ap5.force.com/';
        controllerVar.EmailSenderName = 'DataColada';
        controllerVar.joinBeforeHost = true;
        controllerVar.startParticipantVideo = true;
        controllerVar.enforceLogin = true;
        controllerVar.thankYouEmailNotification = true;
        controllerVar.shareSurveyLink = true;
        controllerVar.shareRecordingURL = true;


        controllerVar.minimumMeetingDuration = 0;
        controllerVar.maximumMeetingDuration = 0;
        controllerVar.joinBeforeHost = true;
        controllerVar.startParticipantVideo = true;
        controllerVar.allowMultipleDevices = true;
        controllerVar.defaultsToHDVideo = true;
        controllerVar.startVideoWhenHostJoin = true;
        controllerVar.startVideoWhenPanelistJoin = true;
        controllerVar.SaveConfigurationDetails();


        controllerVar.minimumMeetingDuration = 10;
        controllerVar.maximumMeetingDuration = 100;
        controllerVar.SaveConfigurationDetails();

        Zoom_Configuration_Settings__c zoomConfigurationDetails = Zoom_Configuration_Settings__c.getValues(Label.Config_Details_Custom_Setting_Name);
        // system.debug('zoomConfigurationDetails'+zoomConfigurationDetails);
        // System.assertEquals('Test_API_Key', zoomConfigurationDetails.Zoom_API_Key__c);
        // System.assertEquals('Test_API_Secret', zoomConfigurationDetails.Zoom_API_Secret__c);
        // System.assertEquals('https://zoom.us/j/', zoomConfigurationDetails.Zoom_URL__c);
        // System.assertEquals(true, zoomConfigurationDetails.Enforce_Login__c);
        // System.assertNotEquals(0, zoomConfigurationDetails.Maximum_Meeting_Duration__c);
        // System.assertNotEquals(0, zoomConfigurationDetails.Minimum_Meeting_Duration__c);
        // System.assertEquals(100, zoomConfigurationDetails.Maximum_Meeting_Duration__c);
        // System.assertEquals(10, zoomConfigurationDetails.Minimum_Meeting_Duration__c);
        // System.assertNotEquals(false, zoomConfigurationDetails.Join_Before_Host__c);

        controllerVar.EditConfigurationDetails();
        System.assertEquals(true, controllerVar.isUpdate);
        controllerVar.CancelConfigurationDetails();
        Test.stopTest();
        System.assertEquals(false, controllerVar.isUpdate);
    }

    /******************************************************************************************************************
        Method Name  : TestConfigDetailsControllerLoadConfigEditAndSave
        Description  : It verifies load existing configuration, edit and save operation of the Zoom Configuration page.
        Date         : 01 Nov 2018.
        Author       : DataColada Pty Ltd
    *******************************************************************************************************************/
    @isTest
    static void TestConfigDetailsControllerLoadConfigEditAndSave(){

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        Zoom_Configuration_Settings__c zoomConfigurationDetails = new Zoom_Configuration_Settings__c();
        zoomConfigurationDetails.Name = 'Zoom Settings';

        zoomConfigurationDetails.Zoom_API_Key__c = 'Test_API_Key';
        zoomConfigurationDetails.Zoom_API_Secret__c = 'Test_API_Secret';
        zoomConfigurationDetails.Zoom_Integration_User_Email__c = 'admin@datacolada.com';
        zoomConfigurationDetails.Zoom_URL__c = 'https://zoom.us/j/';
        zoomConfigurationDetails.Site_URL__c = 'https://datacoladasfzoom-developer-edition.ap5.force.com/';
        zoomConfigurationDetails.Email_Sender_Name__c = 'DataColada';
        zoomConfigurationDetails.Enforce_Login__c = true;
        zoomConfigurationDetails.Join_Before_Host__c = true;
        zoomConfigurationDetails.Start_Participant_Video_on_Join__c = true;

        zoomConfigurationDetails.Maximum_Meeting_Duration__c = 30;
        zoomConfigurationDetails.Minimum_Meeting_Duration__c = 20;

        zoomConfigurationDetails.Allow_Multiple_Devices__c = true;
        zoomConfigurationDetails.Crypto_Key__c = 'test1234';
        zoomConfigurationDetails.Zoom_Account_User_Id__c = 'testUserId';
                zoomConfigurationDetails.HD_Video__c = true;
        zoomConfigurationDetails.Host_Video__c = true;
        zoomConfigurationDetails.Panelist_Video__c = true;
        zoomConfigurationDetails.Zoom_Authorization_Token__c = 'test_authorization_token';
        zoomConfigurationDetails.Allow_Multiple_Devices__c = true;
        zoomConfigurationDetails.Send_Thank_you_email_notification__c = true;
        zoomConfigurationDetails.Share_Recording_URL__c = true;
        zoomConfigurationDetails.Share_Survey_Link__c = true;

        INSERT zoomConfigurationDetails;

        Zoom_Configuration_Settings__c zoomConfigurationDetailsInserted = Zoom_Configuration_Settings__c.getValues('Zoom Settings');
        System.assertNotEquals(null, zoomConfigurationDetailsInserted);

        SFZoom_ConfigDetailsController controllerVar = new SFZoom_ConfigDetailsController();

        System.assertEquals('Test_API_Key', controllerVar.zoomAPIKey);
        System.assertEquals('Test_API_Secret', controllerVar.ZoomAPISecret);
        System.assertNotEquals('https://zoom.us', controllerVar.ZoomURL);
        System.assertEquals(true, controllerVar.joinBeforeHost);
        System.assertEquals(true, controllerVar.startParticipantVideo);
        System.assertEquals(true, controllerVar.enforceLogin);
        System.assertEquals(true, controllerVar.thankYouEmailNotification);
        System.assertEquals(true, controllerVar.shareSurveyLink);
        System.assertEquals(true, controllerVar.shareRecordingURL);

        Test.startTest();
        controllerVar.EditConfigurationDetails();
        System.assertEquals(true, controllerVar.isUpdate);

        controllerVar.ZoomURL = 'https://zoom.us/j/';
        controllerVar.SaveConfigurationDetails();
        Test.stopTest();
        System.assertEquals('https://zoom.us/j/', zoomConfigurationDetails.Zoom_URL__c);
    }

    /******************************************************************************************************************
        Method Name  : testGetFromEmailOptions
        Description  : It verifies the send email.
        Date         : 27 sept 2024.
        Author       : DataColada Pty Ltd
    *******************************************************************************************************************/

    @isTest
    static void testGetFromEmailOptions() {

        // Create an instance of the class that contains the method
        SFZoom_ConfigDetailsController instance = new SFZoom_ConfigDetailsController();

        // Call the method
        List<SelectOption> options = instance.getFromEmailOptions();

        // Assert that the list is not null and contains the expected number of options
        System.assertNotEquals(null, options, 'The options list should not be null');
        //System.assertEquals(3, options.size(), 'There should be 2 options: Current User and Org Wide Email');

        // Assert the first option (Current User's Email)
        SelectOption currentUserOption = options[0];
        System.assertEquals(UserInfo.getUserEmail(), currentUserOption.getValue(), 'The first option should be the current user\'s email');
        System.assertEquals('Current User\'s Email Address <'+UserInfo.getUserEmail()+'>', currentUserOption.getLabel(), 'The label for the current user\'s email should be correct');

    }

    /******************************************************************************************************************
        Method Name  : testResetThankYouSetting
        Description  : It verifies the Reset Thankyou setting.
        Date         : 27 sept 2024.
        Author       : DataColada Pty Ltd
    *******************************************************************************************************************/

    static testMethod void testResetThankYouSetting() {
        SFZoom_ConfigDetailsController controller = new SFZoom_ConfigDetailsController();
        controller.thankYouEmailNotification = false;

        controller.resetThankYouSetting();

        System.assertEquals(false, controller.shareRecordingURL);
        System.assertEquals(false, controller.shareSurveyLink);
    }

     /******************************************************************************************************************
        Method Name  : testSFZoom_ConfigDetailsController
        Description  : It verifies load existing configuration, edit and save operation of the Zoom Configuration page.
        Date         : 30 sept 2024.
        Author       : DataColada Pty Ltd
    *******************************************************************************************************************/

     // Mock class for HTTP callout
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // Create a mock response for the Zoom API
            HTTPResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            res.setBody('{"id": "mockZoomUserId"}'); // Mock response with a user ID
            return res;
        }
    }

    @isTest
    static void testSFZoom_ConfigDetailsController() {
        // Create a test Zoom Configuration Settings record
        Zoom_Configuration_Settings__c config = new Zoom_Configuration_Settings__c(
            Name = 'Test Config',
            Zoom_API_Key__c = 'testAPIKey',
            Zoom_API_Secret__c = 'testAPISecret'
        );

        insert config;

        // Instantiate the controller
        Test.startTest();

        SFZoom_ConfigDetailsController controller = new SFZoom_ConfigDetailsController();
        controller.zoomAPIKey = 'testAPIKey';
        controller.ZoomAPISecret = 'testAPISecret';

        // Test validation method
        controller.zoomAPIKey = '';
        Boolean isValid = controller.validateConfigurationDetails();
        System.assertEquals(false, isValid, 'Validation should fail when required fields are missing.');

        // Test VerifyAuthorizationTokenAndSaveUserId method
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        String accessToken = 'Bearer testAccessToken';
        String zoomUserEmail = 'testuser@example.com';
        String zoomAccountUserId = SFZoom_ConfigDetailsController.VerifyAuthorizationTokenAndSaveUserId(accessToken, zoomUserEmail);

        // Validate the returned user ID
        System.assertEquals('mockZoomUserId', zoomAccountUserId, 'The returned Zoom account user ID should match the mock response.');

        // Clean up
        delete config;

        Test.stopTest();
    }

     /******************************************************************************************************************
        Method Name  : TestSaveConfigurationDetails
        Description  : It verifies load existing configuration, edit and save operation of the Zoom Configuration page.
        Date         : 1 Oct 2024.
        Author       : DataColada Pty Ltd
    *******************************************************************************************************************/

        @isTest
    static void TestSaveConfigurationDetails() {
        // Set up the mock response for the HTTP callout
        Test.setMock(HttpCalloutMock.class, new SFZoom_VerifyAuthAndSaveCalloutMock());

        // Create a test Zoom Configuration Settings record
        Zoom_Configuration_Settings__c zoomConfigurationDetails = new Zoom_Configuration_Settings__c();
        zoomConfigurationDetails.Name = 'Zoom Settings';
        zoomConfigurationDetails.Zoom_API_Key__c = 'Test_API_Key';
        zoomConfigurationDetails.Zoom_API_Secret__c = 'Test_API_Secret';
        zoomConfigurationDetails.Zoom_Integration_User_Email__c = 'admin@datacolada.com';
        zoomConfigurationDetails.Zoom_Account_User_Id__c = 'testUserId';
        zoomConfigurationDetails.Zoom_Authorization_Token__c = 'test_authorization_token';

        INSERT zoomConfigurationDetails;

        Zoom_Configuration_Settings__c zoomConfigurationDetailsInserted = Zoom_Configuration_Settings__c.getValues('Zoom Settings');
        System.assertNotEquals(null, zoomConfigurationDetailsInserted, 'Inserted Zoom Configuration record should not be null.');

        // Call the method and verify the result
        Test.startTest();
        // Simulate the callout by invoking the method
        String AccountUserId = SFZoom_ConfigDetailsController.VerifyAuthorizationTokenAndSaveUserId(
            zoomConfigurationDetails.Zoom_Authorization_Token__c,
            zoomConfigurationDetails.Zoom_Integration_User_Email__c
        );

        Test.stopTest();

        // Assert that the zoomAccountUserId is set correctly based on the mock response
        //System.assertNotEquals('testUserId', AccountUserId, 'The Zoom account user ID should match the mock response.');
    }
 }
