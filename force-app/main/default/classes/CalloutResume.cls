public class CalloutResume {
    public class ResponseException extends Exception {}
    public List<Candidate__c> candidatesList;
    public HttpResponse responseService;

    public class OAuth2{
 		public String ACCESS_TOKEN{get;set;}
	}
    
    public List<Candidate__c> getCalloutResponseContents() {
        Http ourHttp = new Http();
        HttpRequest requestForToken = RequestClass.createRequestForToken('GET');
        HttpResponse responseToken = ourHttp.send(requestForToken);
        OAuth2 objAuthenticationInfo = (OAuth2)JSON.deserialize(responseToken.getbody(), OAuth2.class);

		if(objAuthenticationInfo.ACCESS_TOKEN != null) {
            HttpRequest requestForService = RequestClass.createRequestForService(objAuthenticationInfo.ACCESS_TOKEN, 'GET', 'resumeEndpoint');
            responseService = ourHttp.send(requestForService);
            if(responseService.getStatusCode() == 200) {
                System.debug('ALL EXISTING Resumes:  ' + responseService.getBody());
                candidatesList = (List<Candidate__c>)JSON.deserialize(responseService.getBody(), List<Candidate__c>.class);
                for(Candidate__c can : candidatesList) {
                    can.Id = null;
                }
                return candidatesList;
            }
            else throw new ResponseException(System.Label.Service_Error_at_the_Callout_level + ' ' + System.Label.Status_code_is_not_200);
        }
        else throw new ResponseException(System.Label.Service_Error_at_the_Callout_level + ' ' + System.Label.Access_Token_is_null);
    }
    
    public List<ContentVersion> getContentVersionList(List<Id> candidateId){
        List<ContentVersion> contentVersionList = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE FirstPublishLocationId =: candidateId];
        return contentVersionList;
    }
    
    public void insertCurrentContentVersion(){
        List<Id> temporaryDeleteFilesList = new List<Id>();
        List<Candidate__c> temporaryInsertCandidateList = new List<Candidate__c>();
        List<ContentVersion> currentContentVersionList = new List<ContentVersion>();
        
        for(Candidate__c temporaryCandidate : candidatesList) {
            if(temporaryCandidate.Photo_Code__c != null) {
                temporaryDeleteFilesList.add(temporaryCandidate.Id);
                        
                ContentVersion currentContentVersion = new ContentVersion(
                    Title = temporaryCandidate.Photo_Title__c,
            		PathOnClient = temporaryCandidate.Photo_PathOnClient__c,
            		VersionData = EncodingUtil.base64Decode(temporaryCandidate.Photo_Code__c),
            		FirstPublishLocationId = temporaryCandidate.Id
                );
                currentContentVersionList.add(currentContentVersion);
            }
        }
        deletePreviousFiles(temporaryDeleteFilesList);
        
        try{
        	insert currentContentVersionList;
        } catch(DMLException e){
            throw new ResponseException(System.Label.Service_Error_at_the_Callout_level + ' ' + e.getMessage());
        }
                
        for(Candidate__c temporaryCandidateForCleaning : candidatesList) {
            if(temporaryCandidateForCleaning.Photo_Code__c != null) {
                temporaryCandidateForCleaning.Photo_Code__c = null;
                temporaryInsertCandidateList.add(temporaryCandidateForCleaning);
        	}
        }
        
        try{
        	update temporaryInsertCandidateList;
        } catch(DMLException e){
            throw new ResponseException(System.Label.Service_Error_at_the_Callout_level + ' ' + e.getMessage());
        }
    }
        
    public void deletePreviousFiles(List<Id> candidateId) {
        List<ContentVersion> contentVersionList = getContentVersionList(candidateId);
        List<ContentDocument> contentDocumentList = new List <ContentDocument>();
        Set<Id> contentDocumentIdsSet = new Set<Id>();
        
        for(ContentVersion temporaryContentVersion : contentVersionList){
            contentDocumentIdsSet.add(temporaryContentVersion.ContentDocumentId);
        }
        Map<Id, ContentDocument> contentDocumentsMap = new Map<Id, ContentDocument>([SELECT Id FROM ContentDocument WHERE Id IN : contentDocumentIdsSet]);
        
        for(ContentDocument temporaryContentDocument : contentDocumentsMap.values()){
            contentDocumentList.add(temporaryContentDocument); 
        }
        
        try{
        	delete contentDocumentList;
        } catch(DMLException e){
            throw new ResponseException(System.Label.Service_Error_at_the_Callout_level + ' ' + e.getMessage());
        } 
    } 
}