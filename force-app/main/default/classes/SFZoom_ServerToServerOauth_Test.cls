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
 * @description       : ZoomServerToServer connector Test
 * @author            : DataColada Pty Ltd
 * @group             :
 * @last modified on  : 29-03-2023
 * @last modified by  : DataColada Pty Ltd
**/
@isTest
public with sharing class SFZoom_ServerToServerOauth_Test {
    /**
     * @description       : instance test
     * @author            : DataColada Pty Ltd
     * @group             :
     * @last modified on  : 29-03-2023
     * @last modified by  : DataColada Pty Ltd
    **/
    @isTest
    public static void instanceTest() {

        Test.setMock(HttpCalloutMock.class, new SFZoom_ServerToServerOauthMock());
        System.assert(SFZoom_ServerToServerOauth.Instance() != null);
      }
    /**
     * @description       : access token test
     * @author            : DataColada Pty Ltd
     * @group             :
     * @last modified on  : 29-03-2023
     * @last modified by  : DataColada Pty Ltd
    **/
    @isTest
    public static void getAccessTokenTest() {

        Test.setMock(HttpCalloutMock.class, new SFZoom_ServerToServerOauthMock());
        
        SFZoom_ServerToServerOauth connector = SFZoom_ServerToServerOauth.Instance();
        String access_token = connector.getAccessToken();
        System.assertEquals('token1234', access_token);
      }
}