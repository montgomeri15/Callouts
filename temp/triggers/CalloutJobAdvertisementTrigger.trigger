trigger CalloutJobAdvertisementTrigger on Position__c (after insert, after update) {
    public class TriggerException extends Exception {}
    
    for(Position__c position : Trigger.new){
        if(position.Status__c == 'Closed'){
            try{
                CalloutJobAdvertisementHelper.changeStatusCallout(position.Id);
            } catch(Exception e){
                position.Status__c.addError('Status change error:  ' + e.getMessage());
            }
        } 
    }
}