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
public with sharing class SFZoom_EmailService_Test {

    /******************************************************************************************************************
        Method Name  :
        Description  :Test that we can add messages to the queue
        Date         : 09 Dec 2020
        Author       : DataColada Pty Ltd
    *******************************************************************************************************************/
    @isTest
    static void emailMessagesInQueueTest() {

        SFZoom_EmailService.enqueue(SFZoom_EmailService.createEmailDataObject().setEmailSubject('Testing Subject')
            .setHtmlBody('Testing Message body')
            .setSenderDisplayName('DataColada')
            .setTargetObjectId(null)
            .setTemplateId(null)
            .setReplyTo('admin@datacolada.com')
            .setlistOfCCEmailAddress( new List<string>{'admin@datacolada.com'})
        );

        System.assert(!SFZoom_EmailService.isEmpty());
    }
    /******************************************************************************************************************
        Method Name  :
        Description  :Test that we can clear the queue
        Date         : 09 Dec 2020
        Author       : DataColada Pty Ltd
    *******************************************************************************************************************/
    @isTest
    static void clearEmailMessagesTest() {

        SFZoom_EmailService.enqueue(SFZoom_EmailService.createEmailDataObject().setEmailSubject('Testing Subject')
            .setHtmlBody('Testing Message body')
            .setSenderDisplayName('DataColada')
            .setTargetObjectId(null)
            .setTemplateId(null)
            .setReplyTo('admin@datacolada.com')
            .setlistOfCCEmailAddress( new List<string>{'admin@datacolada.com'})
        );

        SFZoom_EmailService.clear();

        System.assert(SFZoom_EmailService.isEmpty());
    }
    /******************************************************************************************************************
        Method Name  :
        Description  :Test that we can flush all the emails (send them out) out.
        Date         : 09 Dec 2020
        Author       : DataColada Pty Ltd
    *******************************************************************************************************************/
    @isTest
    static void flushEmailMessagesTest() {

        SFZoom_EmailService.enqueue(SFZoom_EmailService.createEmailDataObject().setEmailSubject('Testing Subject')
            .setHtmlBody('Testing Message body')
            .setSenderDisplayName('DataColada')
            .setTargetObjectId(null)
            .setTemplateId(null)
            .setReplyTo('admin@datacolada.com')
            .setlistOfCCEmailAddress( new List<string>{'admin@datacolada.com'})
        );

        System.assert(SFZoom_EmailService.flush() != null);
    }
    /******************************************************************************************************************
        Method Name  :
        Description  :Test that we can get an instance of the EmailData Object
        Date         : 10 Dec 2020
        Author       : DataColada Pty Ltd
    *******************************************************************************************************************/
    @isTest
    static void createEmailDataObjectTest() {

        System.assert(SFZoom_EmailService.createEmailDataObject() != null);
    }
    /******************************************************************************************************************
        Method Name  :
        Description  :
        Date         : 10 Dec 2020
        Author       : DataColada Pty Ltd
    *******************************************************************************************************************/
    @isTest
    static void setEmailSubjectTest() {
        System.AssertEquals( SFZoom_EmailService.createEmailDataObject().setEmailSubject('Subject').getEmailSubject(), 'Subject');
    }
    /******************************************************************************************************************
        Method Name  :
        Description  :
        Date         : 10 Dec 2020
        Author       : DataColada Pty Ltd
    *******************************************************************************************************************/
    @isTest
    static void setHtmlBodyTest() {
        System.AssertEquals( SFZoom_EmailService.createEmailDataObject().setHtmlBody('body').getHtmlBody(), 'body');
    }
    /******************************************************************************************************************
        Method Name  :
        Description  :
        Date         : 10 Dec 2020
        Author       : DataColada Pty Ltd
    *******************************************************************************************************************/
    @isTest
    static void setSenderDisplayNameTest() {
        System.AssertEquals( SFZoom_EmailService.createEmailDataObject().setSenderDisplayName('DataColada').getSenderDisplayName(), 'DataColada');
    }
    /******************************************************************************************************************
        Method Name  :
        Description  :
        Date         : 10 Dec 2020
        Author       : DataColada Pty Ltd
    *******************************************************************************************************************/
    @isTest
    static void setTargetObjectId() {
        System.AssertEquals( SFZoom_EmailService.createEmailDataObject().setTargetObjectId('1234').getTargetObjectId(), '1234');
    }
    /******************************************************************************************************************
        Method Name  :
        Description  :
        Date         : 10 Dec 2020
        Author       : DataColada Pty Ltd
    *******************************************************************************************************************/
    @isTest
    static void setTemplateIdTest() {
        System.AssertEquals( SFZoom_EmailService.createEmailDataObject().setTemplateId('1234').getTemplateId(), '1234');
    }
    /******************************************************************************************************************
        Method Name  :
        Description  :
        Date         : 10 Dec 2020
        Author       : DataColada Pty Ltd
    *******************************************************************************************************************/
    @isTest
    static void setReplyToTest() {
        System.AssertEquals( SFZoom_EmailService.createEmailDataObject().setReplyTo('admin@datacolada.com').getReplyTo(), 'admin@datacolada.com');
    }
    /******************************************************************************************************************
        Method Name  :
        Description  :
        Date         : 10 Dec 2020
        Author       : DataColada Pty Ltd
    *******************************************************************************************************************/
    @isTest
    static void setlistOfCCEmailAddressTest() {
        System.AssertEquals( SFZoom_EmailService.createEmailDataObject().setlistOfCCEmailAddress( new List<String>{'admin@datacolada.com'}).getlistOfCCEmailAddress().size(), 1);
    }

}
