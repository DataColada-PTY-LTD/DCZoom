/******************************************************************************************************************
    Method Name  : SFZoom_EmailService
    Description  : This class should be used for outbound emails.It will replace what is currently being used
    Date         : 04 Dec 2020
    Author       : DataColada Pty Ltd
*******************************************************************************************************************/
public without sharing class SFZoom_EmailService implements Queueable  {
    private final Integer MAX_EMAILS_PER_TRANSACTION = 100;
    private static List<EmailData> queue = new List<EmailData>();          //Queue up all Email Requests
    private List<EmailData> emailDataList;                                 //store a copy for each thread of execution

    /******************************************************************************************************************
        Method Name  : EmailData - Data storage structure
        Description  : Store the necessary information that needs to be passed into the interface
        Date         : 04 Dec 2020
        Author       : DataColada Pty Ltd
    *******************************************************************************************************************/
    public class EmailData {
        private List<String> listOfCCEmailAddress;
        private String htmlBody;
        private String templateId;
        private String senderDisplayName;
        private String replyTo;
        private String emailSubject;
        private String targetObjectId;

        /******************************************************************************************************************
        Method Name  :
        Description  :
        Date         : 10 Dec 2020
        Author       : DataColada Pty Ltd
        *******************************************************************************************************************/
        public SFZoom_EmailService.EmailData setEmailSubject(String emailSubject) {
            this.emailSubject = emailSubject;
            return this;
        }
        /******************************************************************************************************************
        Method Name  :
        Description  :
        Date         : 10 Dec 2020
        Author       : DataColada Pty Ltd
        *******************************************************************************************************************/
        public SFZoom_EmailService.EmailData setHtmlBody(String htmlBody) {
            this.htmlBody = htmlBody;
            return this;
        }
        /******************************************************************************************************************
        Method Name  :
        Description  :
        Date         : 10 Dec 2020
        Author       : DataColada Pty Ltd
        *******************************************************************************************************************/
        public SFZoom_EmailService.EmailData setSenderDisplayName(String senderDisplayName) {
            this.senderDisplayName = senderDisplayName;
            return this;
        }
        /******************************************************************************************************************
        Method Name  :
        Description  :
        Date         : 10 Dec 2020
        Author       : DataColada Pty Ltd
        *******************************************************************************************************************/
        public SFZoom_EmailService.EmailData setTargetObjectId(String targetObjectId) {
            this.targetObjectId = targetObjectId;
            return this;
        }
        /******************************************************************************************************************
        Method Name  :
        Description  :
        Date         : 10 Dec 2020
        Author       : DataColada Pty Ltd
        *******************************************************************************************************************/
        public SFZoom_EmailService.EmailData setTemplateId(String templateId) {
            this.templateId = templateId;
            return this;
        }
        /******************************************************************************************************************
        Method Name  :
        Description  :
        Date         : 10 Dec 2020
        Author       : DataColada Pty Ltd
        *******************************************************************************************************************/
        public SFZoom_EmailService.EmailData setReplyTo(String replyTo) {
            this.replyTo = replyTo;
            return this;
        }
        /******************************************************************************************************************
        Method Name  :
        Description  :
        Date         : 10 Dec 2020
        Author       : DataColada Pty Ltd
        *******************************************************************************************************************/
        public SFZoom_EmailService.EmailData setlistOfCCEmailAddress(List<String> listOfCCEmailAddress) {
            this.listOfCCEmailAddress = listOfCCEmailAddress;
            return this;
        }
        /******************************************************************************************************************
        Method Name  :
        Description  :
        Date         : 10 Dec 2020
        Author       : DataColada Pty Ltd
        *******************************************************************************************************************/
        public String getEmailSubject() {
            return this.emailSubject;
        }
        /******************************************************************************************************************
        Method Name  :
        Description  :
        Date         : 10 Dec 2020
        Author       : DataColada Pty Ltd
        *******************************************************************************************************************/
        public String getHtmlBody() {
            return this.htmlBody;
        }
        /******************************************************************************************************************
        Method Name  :
        Description  :
        Date         : 10 Dec 2020
        Author       : DataColada Pty Ltd
        *******************************************************************************************************************/
        public String getSenderDisplayName() {
            return this.senderDisplayName;
        }
        /******************************************************************************************************************
        Method Name  :
        Description  :
        Date         : 10 Dec 2020
        Author       : DataColada Pty Ltd
        *******************************************************************************************************************/
        public String getTargetObjectId() {
            return this.targetObjectId;
        }
        /******************************************************************************************************************
        Method Name  :
        Description  :
        Date         : 10 Dec 2020
        Author       : DataColada Pty Ltd
        *******************************************************************************************************************/
        public String getTemplateId() {
            return this.templateId;
        }
        /******************************************************************************************************************
        Method Name  :
        Description  :
        Date         : 10 Dec 2020
        Author       : DataColada Pty Ltd
        *******************************************************************************************************************/
        public String getReplyTo() {
            return this.replyTo;
        }
        /******************************************************************************************************************
        Method Name  :
        Description  :
        Date         : 10 Dec 2020
        Author       : DataColada Pty Ltd
        *******************************************************************************************************************/
        public List<String>  getlistOfCCEmailAddress() {
            return this.listOfCCEmailAddress;
        }
    }
    /******************************************************************************************************************
        Method Name  : SFZoom_EmailService
        Description  : Constructor to initialize a list of EmailData structures
        Date         : 04 Dec 2020
        Author       : DataColada Pty Ltd
    *******************************************************************************************************************/
    public SFZoom_EmailService(List<EmailData> emailDataList) {
        this.emailDataList =  emailDataList;
    }
    /******************************************************************************************************************
        Method Name  : execute
        Description  : Start the email sending process.This is done by salesforce - we conform to the interface
                     : this method also spawns itself again if necessary.
        Date         : 04 Dec 2020
        Author       : DataColada Pty Ltd
    *******************************************************************************************************************/
    public void execute(QueueableContext qc) {
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();

        for(Integer i =0 ; i < emailDataList.size() && i < MAX_EMAILS_PER_TRANSACTION ; i++ ) {
            mails.add(transform(emailDataList.remove(i)));
        }

        if(!mails.isEmpty())  sendEmail(mails);

        if(!emailDataList.isEmpty())  System.enqueueJob(new SFZoom_EmailService(emailDataList));

    }
    /******************************************************************************************************************
        Method Name  : transform
        Description  : Transforms the EmailData structures into valid Messaging SingleEmail Structure
        Date         : 04 Dec 2020
        Author       : DataColada Pty Ltd
    *******************************************************************************************************************/
    private Messaging.SingleEmailMessage transform(EmailData emailData) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        mail.setTargetObjectId(emailData.getTargetObjectId());
        mail.setReplyTo(emailData.getReplyTo());
        mail.setSenderDisplayName(emailData.getSenderDisplayName());

        if(emailData.getlistOfCCEmailAddress() != null && !emailData.getlistOfCCEmailAddress().isEmpty()) mail.setCcAddresses(emailData.getlistOfCCEmailAddress());
        if(String.isNotBlank(emailData.getTemplateId()))  mail.setTemplateId(emailData.getTemplateId());

        mail.setSubject(emailData.getEmailSubject());
        mail.setHtmlBody(emailData.getHtmlBody());

        return mail;
    }
    /******************************************************************************************************************
        Method Name  : sendEmail
        Description  : This is the main routine that calls the underlying Messaging API that is available in salesforce
                     : we wrap this interface and do some pre and post checks after the call is issued
        Date         : 04 Dec 2020
        Author       : DataColada Pty Ltd
    *******************************************************************************************************************/
    private Boolean sendEmail(List<Messaging.SingleEmailMessage> mails) {
        Boolean ret = false;
        System.debug('You have made ' + Limits.getEmailInvocations() + ' email calls out of ' + Limits.getLimitEmailInvocations() + ' allowed');
        if( Limits.getEmailInvocations() < Limits.getLimitEmailInvocations()) {
            Messaging.SendEmailResult[] emailResult = Messaging.sendEmail(mails, false);
            for(Messaging.SendEmailResult returnCode :  emailResult) {
                if(!returnCode.isSuccess()) {
                    System.debug('@@@ SendEmail Errors : ' + returnCode.getErrors());
                    ret = false;
                }
            }
        }
        return ret;
    }
    /******************************************************************************************************************
        Method Name  : enqueue
        Description  : Used to Queue up messages.We use this to build up a list of messages then flush them out
        Date         : 08 Dec 2020
        Author       : DataColada Pty Ltd
    *******************************************************************************************************************/
    public static void enqueue(EmailData message) {
        queue.add(message);
    }
    /******************************************************************************************************************
        Method Name  : flush
        Description  : flushes the message queue.
        Date         : 08 Dec 2020
        Author       : DataColada Pty Ltd
    *******************************************************************************************************************/
    public static String flush() {
        String retCode = null;
        if(!SFZoom_EmailService.queue.isEmpty()) {
            retCode =  System.enqueueJob(new SFZoom_EmailService(SFZoom_EmailService.queue));
        }
        return retCode;
    }
    /******************************************************************************************************************
        Method Name  :
        Description  :
        Date         : 08 Dec 2020
        Author       : DataColada Pty Ltd
    *******************************************************************************************************************/
    public static void clear() {
        SFZoom_EmailService.queue.clear();
    }
    /******************************************************************************************************************
        Method Name  :
        Description  :
        Date         : 08 Dec 2020
        Author       : DataColada Pty Ltd
    *******************************************************************************************************************/
    public static Boolean isEmpty() {
      return SFZoom_EmailService.queue.isEmpty();
    }
    /******************************************************************************************************************
        Method Name  :
        Description  : Expose a Factory method to return an instance of the EmailData Object
        Date         : 09 Dec 2020
        Author       : DataColada Pty Ltd
    *******************************************************************************************************************/
    public static EmailData createEmailDataObject() {
        return new EmailData();
    }
}
