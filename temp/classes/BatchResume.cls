global class BatchResume implements Database.Batchable<Integer>, Database.AllowsCallouts {
    CalloutResume calloutResume = new CalloutResume();
    
    global Integer operationsQuantity = 1;
    global Iterable<Integer> start(Database.BatchableContext BC){
        List<Integer> scope = new List<Integer>();
		for(integer i = 1; i <= operationsQuantity; i++){
			scope.add(i);
		}
		return scope;
    }
    
    global void execute(Database.BatchableContext BC, List<Integer> scope){
       	List<Candidate__c> mainList = new List<Candidate__c>();
        for(Integer i : scope){
            List<Candidate__c> candidatesList = calloutResume.getCalloutResponseContents();
            mainList.addAll(candidatesList);
        }
        try{
            upsert mainList Email__c;
        } catch(Exception e){
            System.debug(e.getMessage()); 
        }
        calloutResume.insertCurrentContentVersion(); 
    }
    
    global void finish(Database.BatchableContext BC){
    }
}