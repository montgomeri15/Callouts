global class BatchResume implements Database.Batchable<Integer>, Database.AllowsCallouts {
    CalloutResume calloutResume = new CalloutResume();
    CalloutEmailSending calloutEmailSending = new CalloutEmailSending();
    
    global Integer operationsQuantity = 1;
    global Iterable<Integer> start(Database.BatchableContext BC){
        List<Integer> scope = new List<Integer>();
		for(integer i = 1; i <= operationsQuantity; i++){
			scope.add(i);
		}
		return scope;
    }
    
    global void execute(Database.BatchableContext BC, List<Integer> scope){
        User user = [SELECT Email FROM User WHERE Profile.Name = 'System Administrator' LIMIT 1];
       	List<Candidate__c> mainList = new List<Candidate__c>();
        
        for(Integer i : scope){
            try{
                List<Candidate__c> candidatesList = calloutResume.getCalloutResponseContents();
            	mainList.addAll(candidatesList);
            } catch(calloutResume.ResponseException e){
                calloutEmailSending.notifyAdministrator(new List<String>{ user.Email }, e.getMessage());
            }  
        }
        
        try{
            upsert mainList Email__c;
        } catch(DMLException e){
            calloutEmailSending.notifyAdministrator(new List<String>{ user.Email }, e.getMessage());
        }
        
        try{
            calloutResume.insertCurrentContentVersion(); 
        } catch(calloutResume.ResponseException e){
            calloutEmailSending.notifyAdministrator(new List<String>{ user.Email }, e.getMessage());
        }
    }
    
    global void finish(Database.BatchableContext BC){
    }
}