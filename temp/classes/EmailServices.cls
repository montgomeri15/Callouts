global with sharing class EmailServices {
    
    public void sendEmail(List<Id> recipients){
        
        Messaging.MassEmailMessage mail = new Messaging.MassEmailMessage();
        
        mail.templateId = '00X1r000002YH5i';
        mail.targetObjectIds = recipients;
        mail.saveAsActivity = false;
        
        try{
        	Messaging.sendEmail(new Messaging.MassEmailMessage[] { mail });
 		}catch(EmailException emlEx) {
        	System.debug('We have a problem here: ' + emlEx.getmessage());
        }  
    }
}