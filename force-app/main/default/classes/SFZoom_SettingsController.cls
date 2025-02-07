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
    Class Name  : SFZoom_SettingsController
    Description : This class is responsible for saving configuration details for Salesforce and Zoom Integration.
    Date        : 02 Jan 2024.
    Author       : DataColada Pty Ltd
*******************************************************************************************************************/
public with sharing class SFZoom_SettingsController {

    /******************************************************************************************************************
    Class Name  : SFZoom_SettingsController
    Description : This method is responsible for retreiving configuration details forom Salesforce .
    Date        : 02 Jan 2024.
    Author       : DataColada Pty Ltd
    *******************************************************************************************************************/
    @AuraEnabled(cacheable=true)
    public static Zoom_Configuration_Settings__c getZoomConfigurationSettings() {
        try {
            String configName = Label.Config_Details_Custom_Setting_Name;
            Zoom_Configuration_Settings__c zoomConfig = Zoom_Configuration_Settings__c.getValues(configName);

            if(zoomConfig != null) {
                //use the default key if the user has not supplied one
                if(zoomConfig.Crypto_Key__c == null) {
                    zoomConfig.Crypto_Key__c = Label.Default_Crypto_Key;
                }

                return zoomConfig;
            }else{
                System.debug('Please contact your system administrator to verify the Zoom Configuration Settings ');
                return null;
            }

        } catch (Exception e) {
            System.debug('Error in retrieving Zoom Configuration Settings: ' + e.getMessage());
            return null;
        }
    }

    /******************************************************************************************************************
    Class Name  : SFZoom_SettingsController
    Description : This method is responsible for saving configuration details for Salesforce and Zoom Integration.
    Date        : 02 Jan 2024.
    Author       : DataColada Pty Ltd
    *******************************************************************************************************************/
    @AuraEnabled
    public static Boolean createZoomConfigurationSettings(Map<String, Object> inputValues) {

        try {
            String name = System.Label.Config_Details_Custom_Setting_Name;

            Zoom_Configuration_Settings__c zoomConfigurationDetails =  Zoom_Configuration_Settings__c.getValues(name);

            // ** If the record doesn't exist, create a new instance
            if (zoomConfigurationDetails == null) {
                zoomConfigurationDetails = new Zoom_Configuration_Settings__c();
                zoomConfigurationDetails.Name = name;
            }

            if (inputValues.containsKey('zoomUrl')) {
                zoomConfigurationDetails.Zoom_URL__c = (String) inputValues.get('zoomUrl');
            }
            if (inputValues.containsKey('zoomUserEmail')) {
                zoomConfigurationDetails.Zoom_Integration_User_Email__c = (String) inputValues.get('zoomUserEmail');
            }
            if (inputValues.containsKey('siteURL')) {
                zoomConfigurationDetails.Site_URL__c = (String) inputValues.get('siteURL');
            }
            if (inputValues.containsKey('zoomAccUserId')) {
                zoomConfigurationDetails.Zoom_Account_User_Id__c = (String) inputValues.get('zoomAccUserId');
            }
            if (inputValues.containsKey('cryptoKey')) {
                zoomConfigurationDetails.Crypto_Key__c = (String) inputValues.get('cryptoKey');
            }
            if (inputValues.containsKey('zoomApiPageSz')) {
                zoomConfigurationDetails.Zoom_API_Page_Size__c = (String) inputValues.get('zoomApiPageSz');
            }
            if (inputValues.containsKey('emailSenderName')) {
                zoomConfigurationDetails.Email_Sender_Name__c = (String) inputValues.get('emailSenderName');
            }
            if (inputValues.containsKey('fromEmailAdd')) {
                zoomConfigurationDetails.From_Email_Address__c = (String) inputValues.get('fromEmailAdd');
            }
            if (inputValues.containsKey('enforceLogin')) {
                zoomConfigurationDetails.Enforce_Login__c = (Boolean) inputValues.get('enforceLogin');
            }
            if (inputValues.containsKey('thankEmailNotify')) {
                zoomConfigurationDetails.Send_Thank_you_email_notification__c = (Boolean) inputValues.get('thankEmailNotify');
            }
            if (inputValues.containsKey('shareSurveyLink')) {
                zoomConfigurationDetails.Share_Survey_Link__c = (Boolean) inputValues.get('shareSurveyLink');
            }
            if (inputValues.containsKey('shareRecUrl')) {
                zoomConfigurationDetails.Share_Recording_URL__c = (Boolean) inputValues.get('shareRecUrl');
            }
            if (inputValues.containsKey('minMeetDuration')) {
                zoomConfigurationDetails.Minimum_Meeting_Duration__c =  Decimal.valueOf((String) inputValues.get('minMeetDuration'));
            }
            if (inputValues.containsKey('maxMeetDuration')) {
                zoomConfigurationDetails.Maximum_Meeting_Duration__c =  Decimal.valueOf((String) inputValues.get('maxMeetDuration'));
            }
            if (inputValues.containsKey('joinBeforeHost')) {
                zoomConfigurationDetails.Join_Before_Host__c = (Boolean) inputValues.get('joinBeforeHost');
            }
            if (inputValues.containsKey('startPartVideo')) {
                zoomConfigurationDetails.Start_Participant_Video_on_Join__c = (Boolean) inputValues.get('startPartVideo');
            }
            if (inputValues.containsKey('allowAttendes')) {
                zoomConfigurationDetails.Allow_Multiple_Devices__c = (Boolean) inputValues.get('allowAttendes');
            }
            if (inputValues.containsKey('byDefaultBroad')) {
                zoomConfigurationDetails.HD_Video__c = (Boolean) inputValues.get('byDefaultBroad');
            }
            if (inputValues.containsKey('startVideoHostJoin')) {
                zoomConfigurationDetails.Host_Video__c = (Boolean) inputValues.get('startVideoHostJoin');
            }
            if (inputValues.containsKey('startVideoPaneJoin')) {
                zoomConfigurationDetails.Panelist_Video__c = (Boolean) inputValues.get('startVideoPaneJoin');
            }
            // **  Oauth=========
            if (inputValues.containsKey('accountId')) {
                zoomConfigurationDetails.Oauth_Account_Id__c = (String) inputValues.get('accountId');
            }
            if (inputValues.containsKey('clientId')) {
                zoomConfigurationDetails.Oauth_Client_Id__c = (String) inputValues.get('clientId');
            }
            if (inputValues.containsKey('clientSecret')) {
                zoomConfigurationDetails.oauth_client_secret__c = (String) inputValues.get('clientSecret');
            }
            if (inputValues.containsKey('webhookSecretToken')) {
                zoomConfigurationDetails.Zoom_Webhook_Secret_Token__c = (String) inputValues.get('webhookSecretToken');
            }
            if (inputValues.containsKey('enableOAuth')) {
                zoomConfigurationDetails.Oauth_Connection__c = (Boolean) inputValues.get('enableOAuth');
            }
            // upsert zoomConfigurationDetails;
            Database.upsertResult saveResult =  Database.upsert(zoomConfigurationDetails, Zoom_Configuration_Settings__c.Name);
            if (saveResult.isSuccess()){
                return true;
            } else{
                return false;
            }
        } catch (Exception e) {
            System.debug('Error in creating or updating record: ' + e.getMessage());
            return false;
        }
    }
    /******************************************************************************************************************
    Class Name  : SFZoom_SettingsController
    Description : This method is responsible for aouth response for Salesforce and Zoom Integration.
    Date        : 02 Jan 2024.
    Author      : DataColada Pty Ltd

    History
    -----------------
    13-01-2025  DataColada Pty Ltd connecting controller to the auth server
    *******************************************************************************************************************/
    @AuraEnabled
    public static String getOAuthTestResponse() {

        try {
            return  checkAccessTokenForSuccess();

        } catch (Exception e) {
            return 'Error in OAuth test: ' + e.getMessage() + '. Please check your oauth configuration';
        }
    }
    /**
     * @description       :
     * @author            : DataColada Pty Ltd
     * @last modified on  : 13-01-2025
     * @last modified by  : DataColada Pty Ltd
    **/
    private static String checkAccessTokenForSuccess() {
        String retCode;

        String access_token = SFZoom_ServerToServerOauth.Instance().getAccessToken();
        if (access_token == null) {
            return retCode =  'Error obtaining access token';
        }

        if( (retCode = checkForValidZoomUserEmail(access_token)) == null) {
            retCode =  'Access Token Passed , Zoom User Email Passed';
        }

        return retCode;
    }
    /**
     * @description       :
     * @author            : DataColada Pty Ltd
     * @last modified on  : 13-01-2025
     * @last modified by  : DataColada Pty Ltd
    **/
    private static String checkForValidZoomUserEmail(String access_token) {
        String retCode;
        Zoom_Configuration_Settings__c zoomConfig = Zoom_Configuration_Settings__c.getValues(Label.Config_Details_Custom_Setting_Name);

        String email = zoomConfig?.Zoom_Integration_User_Email__c;
        String zoomAccountUserId = SFZoom_ConfigDetailsController.VerifyAuthorizationTokenAndSaveUserId( 'Bearer ' + access_token, email);

        if(zoomAccountUserId == null) {
            retCode = 'Error getting Zoom Account Id : Please check you have configured the correct zoom integration user email.';
        }
        else {
            //check the cache , persist if not equal
            if( zoomConfig != null && zoomConfig.Zoom_Account_User_Id__c != zoomAccountUserId){
                zoomConfig.Zoom_Account_User_Id__c = zoomAccountUserId;
                update zoomConfig;
            }
        }

        return retCode;
    }

}
