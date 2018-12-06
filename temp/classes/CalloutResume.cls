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
            else throw new ResponseException(System.Label.Status_code_is_not_200);
        }
        else throw new ResponseException(System.Label.Access_Token_is_null);
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
        } catch(QueryException e){
            throw new ResponseException(e.getMessage());
        }
                
        for(Candidate__c temporaryCandidate2 : candidatesList) {
            	if(temporaryCandidate2.Photo_Code__c != null) {
                	temporaryCandidate2.Photo__c = [SELECT Id FROM ContentVersion WHERE FirstPublishLocationId =: temporaryCandidate2.Id].Id;
                	temporaryCandidate2.Photo_Code__c = null;
                	temporaryInsertCandidateList.add(temporaryCandidate2);
            	
        	}
        }
        
        try{
        	update temporaryInsertCandidateList;
        } catch(QueryException e){
            throw new ResponseException(e.getMessage());
        }
    }
        
    public void deletePreviousFiles(List<Id> candidateId) {
        List<ContentVersion> contentVersionList = getContentVersionList(candidateId);
        List<ContentDocument> contentDocumentList = new List <ContentDocument>();
        
        for(ContentVersion temporaryContentVersion : contentVersionList){
            try{
                ContentDocument thisContentDocument = [SELECT Id FROM ContentDocument WHERE Id =: temporaryContentVersion.ContentDocumentId];
           		contentDocumentList.add(thisContentDocument); 
            } catch(QueryException e){
                throw new ResponseException(e.getMessage());
            }
        }
        
        try{
            delete contentDocumentList;
        } catch(Exception e){
            throw new ResponseException(e.getMessage());
        }
    } 
}