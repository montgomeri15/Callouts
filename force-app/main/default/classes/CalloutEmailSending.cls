public class CalloutEmailSending {
    
    public void notifyAdministrator(List<String> toAddresses, String errorException){
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.settoAddresses(toAddresses);
        mail.setSubject('The operation failed');
        mail.setPlainTextBody(errorException);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}
