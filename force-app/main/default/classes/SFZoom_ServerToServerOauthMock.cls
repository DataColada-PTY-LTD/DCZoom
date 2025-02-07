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
/**
 * @description       : ZoomServerToServermock class
 * @author            : DataColada Pty Ltd
 * @group             :
 * @last modified on  : 21-09-2022
 * @last modified by  : DataColada Pty Ltd
**/
public with sharing class SFZoom_ServerToServerOauthMock implements HttpCalloutMock {
    /**
     * @description       : provide some test data
     * @author            : DataColada Pty Ltd
     * @group             :
     * @last modified on  : 21-09-2022
     * @last modified by  : DataColada Pty Ltd
     **/
    public HTTPResponse respond(HttpRequest request) {
        HttpResponse response = new HttpResponse();
        response.setBody('{"access_token" : "token1234" , "token_type" : "bearer" , "expires_in": "3599" }');
        response.setStatusCode(200);
        response.setStatus('OK');
        return response;
    }
}