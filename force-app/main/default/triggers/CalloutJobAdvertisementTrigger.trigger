trigger CalloutJobAdvertisementTrigger on Position__c (after insert, after update) {
    public class ResponseException extends Exception {}
    
    for(Position__c position : Trigger.new){
        if(position.Status__c == 'Closed'){
            try{
                CalloutJobAdvertisementHelper.changeStatusCallout(position.Id);
            } catch(Exception e){
                throw new ResponseException('Status change error:  ' + e.getMessage());
            }
        } 
    }
}