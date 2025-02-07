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
/**
 * @description       : SFZoom_ServerToServerOauth connector.
 *                    : We provide a new server to server interface to use as required by Zoom.
 *                    : this interface is used to get the new authorization code from the remote server
 * @author            : DataColada Pty Ltd
 * @group             :
 * @last modified on  : 29-03-2023
 * @last modified by  : DataColada Pty Ltd
**/
public with sharing class SFZoom_ServerToServerOauth {
   
    private static SFZoom_ServerToServerOauth instance;      //holds this instance
    private String access_token;                            //store the access token that was granted by Zoom
    private String token_type;                              //capture the type of token we were given
    private Integer expires_in;                             //capture when this token will expire
    private DateTime now;                                   //capture the time when the callout was made
    private Zoom_Configuration_Settings__c config;          //hold the zoom configuration data



    /**
     * @description       : Singleton, only one oAuth connector will exist
     *                    : inject a config to use
     * @author            : DataColada Pty Ltd
     * @last modified on  : 29-03-2023
     * @last modified by  : DataColada Pty Ltd
    **/
    private SFZoom_ServerToServerOauth() {

        this.config = Zoom_Configuration_Settings__c.getValues('Zoom Settings');
        if(hasTokenExpired()) {
            callout();
        }
    }
    /**
     * @description       : Returns an instance of the connector module
     * @author            : DataColada Pty Ltd
     * @last modified on  : 29-03-2023
     * @last modified by  : DataColada Pty Ltd
    **/
    public static SFZoom_ServerToServerOauth Instance() {
        if(SFZoom_ServerToServerOauth.instance == null) {
            SFZoom_ServerToServerOauth.instance = new SFZoom_ServerToServerOauth();
        }
        return SFZoom_ServerToServerOauth.instance;
    }
    /**
     * @description       : make the callout
     * @author            : DataColada Pty Ltd
     * @last modified on  : 29-03-2023
     * @last modified by  : DataColada Pty Ltd
    **/
    private void callout() {

        String body = 'grant_type=account_credentials&account_id=' + this.config.oauth_account_id__c;
        HttpRequest req = new HttpRequest();

        req.setMethod('POST');
        req.setHeader('Content-type', 'application/x-www-form-urlencoded');
        req.setHeader('Authorization','Basic ' + encodeClientId() );
        
        req.setEndPoint('https://zoom.us/oauth/token');
        req.setBody(body);

        Http http = new Http();
        HttpResponse res = http.send(req);
        if(res.getStatusCode() == 200) {
            parse(res.getBody());
        }

        this.now = System.now();
    }
    /**
     * @description       : parse the json body
     * @author            : DataColada Pty Ltd
     * @last modified on  : 29-03-2023
     * @last modified by  : DataColada Pty Ltd
    **/
    private void parse(String payload) {
            System.JSONParser parser = JSON.createParser(payload);
            while(parser.nextToken() != null) {
                if((parser.getCurrentToken() === JSONToken.FIELD_NAME) && (parser.getText() == 'access_token')) {
                    parser.nextToken();
                    this.access_token = parser.getText();
                }
                else if((parser.getCurrentToken() === JSONToken.FIELD_NAME) && (parser.getText() == 'token_type')) {
                    parser.nextToken();
                    this.token_type = parser.getText();
                }
                else if((parser.getCurrentToken() === JSONToken.FIELD_NAME) && (parser.getText() == 'expires_in')) {
                    parser.nextToken();
                    this.expires_in = Integer.valueOf(parser.getText());
                }
            }
    }
    /**
     * @description       : gets the access token from the connector.We check if the need to do a remote
     *                    : callout, if not then return the cached value as it is still valid
     * @author            : DataColada Pty Ltd
     * @last modified on  : 29-03-2023
     * @last modified by  : DataColada Pty Ltd
    **/
    public String getAccessToken() {

        if(hasTokenExpired()) callout();

        return this.access_token;
    }
    /**
     * @description       : checks if the token has expired.
     *                    : returns true if the token has expired , false otherwise
     * @author            : DataColada Pty Ltd
     * @last modified on  : 29-03-2023
     * @last modified by  : DataColada Pty Ltd
    **/
    private boolean hasTokenExpired() {
        return (this.now == null || this.now.addSeconds(this.expires_in) < System.now()) ? true : false;
    }
    /**
     * @description       : encodes the client id and client secret in base64.
     *                    : the client id and client secrets are stored as meta data
     *                    : returns the formatted encoded values as defined by the Zoom Server
     * @author            : DataColada Pty Ltd
     * @last modified on  : 29-03-2023
     * @last modified by  : DataColada Pty Ltd
    **/
    private String encodeClientId() {
        return EncodingUtil.base64Encode(Blob.valueOf(this.config.oauth_client_id__c + ':' + this.config.oauth_client_secret__c));
    }
    /**
     * @description       : find and return the config used
     * @author            : DataColada Pty Ltd
     * @last modified on  : 13-01-2025
     * @last modified by  : DataColada Pty Ltd
    **/
    public Zoom_Configuration_Settings__c getConfig() {
        return this.config;
    }
}
