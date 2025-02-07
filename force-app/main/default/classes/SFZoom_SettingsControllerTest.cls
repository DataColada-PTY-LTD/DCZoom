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
    Class Name  : SFZoom_SettingsControllerTest
    Description :
    Date        : 07 Jan 2024.
    Author      : DataColada Pty Ltd
*******************************************************************************************************************/
@isTest
public class SFZoom_SettingsControllerTest {
    @TestSetup
    static void setup() {

        Zoom_Configuration_Settings__c zoomConfig = new Zoom_Configuration_Settings__c(
            Zoom_URL__c = 'https://zoom.us',
            Name = Label.Config_Details_Custom_Setting_Name,
            /*Oauth_client_secret__c = 'i1Fdydv5mSer3Oy1vvZCdD158S31HwUT',*/
              Oauth_client_secret__c = 'i1Fdfff5mSer3Oy1vdsCdD158S31HwUT',
            Zoom_API_Page_Size__c = '121',
            Start_Participant_Video_on_Join__c = false,
            Send_Thank_you_email_notification__c = true,
            Host_Video__c = false,
            /*Oauth_Account_Id__c = 'ELd7YI06QLuhVE6FHlZAPA',*/
            Oauth_Account_Id__c = 'ELd7YI06QKufGF8FHlZAPA',
            Share_Recording_URL__c = false,
            HD_Video__c = false,
            Join_Before_Host__c = false,
            Allow_Multiple_Devices__c = false,
            Share_Survey_Link__c = false,
            Enforce_Login__c = false,
            Panelist_Video__c = false,
            Site_URL__c = 'http://www.Test.URL.site1222.com',
            /*Zoom_Account_User_Id__c = 'udT2oat8QNqEKPoQdc4c7w',*/
            Zoom_Account_User_Id__c = 'udT2oat2GHqFDRoQdc4c9b',
            /*Oauth_Client_Id__c = 'WUGSZ5MDTwmM55OjpSR8cQ',*/
            Oauth_Client_Id__c = 'WUGSH6NHGwmM321jpSR8cQ',
            Oauth_Connection__c = true,
            /*Zoom_Webhook_Secret_Token__c = 'iDqi0fxwTVW0G30HjqouXg',*/
            Zoom_Webhook_Secret_Token__c = 'iDqi0fxwGHF0G30HjhgfXg',
            Zoom_Integration_User_Email__c = 'admin+test98@ausdn.org.au',
            Crypto_Key__c = 'r7f6uf6rerye'
        );

        // Insert the record
        insert zoomConfig;

    }

    @IsTest
    static void getZoomConfigurationSettingsTest() {
        Test.startTest();
        Zoom_Configuration_Settings__c result = SFZoom_SettingsController.getZoomConfigurationSettings();
        Test.stopTest();

        System.assertNotEquals(null, result, 'Zoom Configuration Settings should not be null');
        System.assertEquals('https://zoom.us', result.Zoom_URL__c, 'Zoom URL should match the test data');
        System.assertEquals('admin+test98@ausdn.org.au', result.Zoom_Integration_User_Email__c, 'Zoom User Email should match the test data');
    }

    @IsTest
    static void getZoomConfigurationSettings_NegativeTest() {

        delete [SELECT Id FROM Zoom_Configuration_Settings__c WHERE Name = :Label.Config_Details_Custom_Setting_Name];

        Test.startTest();
        Zoom_Configuration_Settings__c result = SFZoom_SettingsController.getZoomConfigurationSettings();
        Test.stopTest();

        System.assertEquals(null, result, 'Zoom Configuration Settings should be null if no configuration exists');
    }

    @IsTest
    static void createZoomConfigurationSettings_NewRecordTest() {
        delete [SELECT Id FROM Zoom_Configuration_Settings__c WHERE Name = :Label.Config_Details_Custom_Setting_Name];

        Map<String, Object> inputValues = new Map<String, Object>{
            'zoomUrl' => 'https://new.zoom.us',
            'zoomUserEmail' => 'new@test.com',
            'siteURL' => 'https://newsite.com',
            'zoomAccUserId' => 'newZoomUserId123',
            'cryptoKey' => 'newCryptoKey456',
            'zoomApiPageSz' => '200',
            'emailSenderName' => 'New Sender Name',
            'fromEmailAdd' => 'sender@test.com',
            'enforceLogin' => true,
            'thankEmailNotify' => true,
            'shareSurveyLink' => false,
            'shareRecUrl' => true,
            'minMeetDuration' => 15,
            'maxMeetDuration' => 300,
            'joinBeforeHost' => false,
            'startPartVideo' => true,
            'allowAttendes' => false,
            'byDefaultBroad' => true,
            'startVideoHostJoin' => true,
            'startVideoPaneJoin' => false,
            'accountId' => 'newAccountId789',
            'clientId' => 'newClientId101112',
            'clientSecret' => 'newClientSecret131415',
            'webhookSecretToken' => 'newWebhookToken161718'
        };


        Test.startTest();
        Boolean result = SFZoom_SettingsController.createZoomConfigurationSettings(inputValues);
        Test.stopTest();

        // System.assert(result, 'Record should be created successfully');

        List<Zoom_Configuration_Settings__c> createdRecord = [SELECT Zoom_URL__c, Zoom_Integration_User_Email__c, Site_URL__c
                                                        FROM Zoom_Configuration_Settings__c
                                                        WHERE Name = :Label.Config_Details_Custom_Setting_Name];
        // System.assertEquals('https://new.zoom.us', createdRecord.Zoom_URL__c, 'Zoom URL should match input values');
        // System.assertEquals('new@test.com', createdRecord.Zoom_Integration_User_Email__c, 'Zoom User Email should match input values');
        // System.assertEquals('https://newsite.com', createdRecord.Site_URL__c, 'Site URL should match input values');
    }




    @IsTest
    static void createZoomConfigurationSettings_UpdateRecordTest() {
        Map<String, Object> inputValues = new Map<String, Object>{
            'zoomUrl' => 'https://updated.zoom.us',
            'zoomUserEmail' => 'updated@test.com'
        };

        Test.startTest();
        Boolean result = SFZoom_SettingsController.createZoomConfigurationSettings(inputValues);
        Test.stopTest();

        System.assert(result, 'Record should be updated successfully');

        Zoom_Configuration_Settings__c updatedRecord = [SELECT Zoom_URL__c, Zoom_Integration_User_Email__c
                                                         FROM Zoom_Configuration_Settings__c
                                                         WHERE Name = :Label.Config_Details_Custom_Setting_Name];
        System.assertEquals('https://updated.zoom.us', updatedRecord.Zoom_URL__c, 'Zoom URL should be updated');
        System.assertEquals('updated@test.com', updatedRecord.Zoom_Integration_User_Email__c, 'Zoom User Email should be updated');
    }

    @IsTest
    static void getOAuthTestResponseTest() {
        // Test.setMock(HttpCalloutMock.class, new SFZoom_ServerToServerOauthMock());
        Test.setMock(HttpCalloutMock.class, new MockHttpCallout());

        Test.startTest();
        Zoom_Configuration_Settings__c createdRecord = [SELECT Zoom_URL__c, Zoom_Integration_User_Email__c, Site_URL__c
                                                        FROM Zoom_Configuration_Settings__c
                                                        WHERE Name = :Label.Config_Details_Custom_Setting_Name];
        String response = SFZoom_SettingsController.getOAuthTestResponse();
        Test.stopTest();

        System.assertEquals('Access Token Passed , Zoom User Email Passed', response, 'OAuth test response should match expected value');
    }


    private class MockHttpCallout implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();

            res.setBody('{"id": "udT2oat8QNqEKPoQdc4c7w" , "access_token" : "token1234" , "token_type" : "bearer" , "expires_in": "3599"}');
            res.setStatusCode(200);
            res.setStatus('OK');

            return res;
        }
    }
}