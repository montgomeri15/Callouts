trigger JobApplicationsCreatingTrigger on Candidate__c (after insert, after update) {
    public class TriggerException extends Exception {}
    List<Position__c> positionList = [SELECT Id FROM Position__c];
    
    if(trigger.isInsert || Trigger.isUpdate){ 
    	for(Candidate__c candidate : Trigger.new){
            for(Position__c position : positionList){
                if(candidate.Position_ID__c.contains(position.Id)){ 
            		try{
                		Job_Application__c jobApplication = new Job_Application__c(
                            Candidate__c = candidate.Id,
                            Position__c = position.Id,
                            ExternalID__c = candidate.Id + ' ' + position.Id 
                        );
                        upsert jobApplication ExternalID__c;
            		} catch(Exception e){
                		candidate.addError('Job Application insert error:  ' + e.getMessage());
            		}
        		}
            }        	
    	}
    }
}