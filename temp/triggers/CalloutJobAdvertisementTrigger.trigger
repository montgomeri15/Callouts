trigger CalloutJobAdvertisementTrigger on Position__c (after insert, after update, before delete) {
    public class TriggerException extends Exception {}
        
    if(trigger.isInsert || Trigger.isUpdate){ 
    	for(Position__c position : Trigger.new){
        	if(position.Status__c == 'Closed'){
            	try{
                	CalloutJobAdvertisementHelper.changeStatusCallout(position.Id, JSON.serialize(position));
            	} catch(Exception e){
                	position.Status__c.addError(e.getMessage());
            	}
        	}
    	}
    }
    
    if(Trigger.isDelete){
        for(Position__c position : Trigger.old){
        	Position__c ourPosition = new Position__c(
        		Id = position.id, 
            	Name = position.name, 
            	Status__c = 'Closed'
            );
            try{
                CalloutJobAdvertisementHelper.changeStatusCallout(ourPosition.Id, JSON.serialize(ourPosition));
            } catch(Exception e){
                System.debug(e.getMessage());  //Или в дебаг/логи для разработчика, или на почту админу
            }
    	}
    }
}