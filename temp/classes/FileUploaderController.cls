public class FileUploaderController {
    public Candidate__c thisCandidate;
    
    public String title{get;set;}
    public String pathOnClient{get;set;}
    public String contentType{get;set;}
    
    public ContentVersion currentContentVersion{get;set;}
    
    public Integer IMAGE_MAX_SIZE = 25000;
    
    public Blob versionData{get;set;}
   
    public FileUploaderController(ApexPages.StandardController controller){
        thisCandidate = (Candidate__c)controller.getRecord();
        List<ContentVersion> contentVersionListForLoop = [SELECT Id FROM ContentVersion WHERE FirstPublishLocationId =: thisCandidate.Id];
        if(!contentVersionListForLoop.isEmpty()){
            currentContentVersion = [SELECT Id FROM ContentVersion WHERE FirstPublishLocationId =: thisCandidate.Id];
        }
    }
    
    public PageReference uploadFile() {
        if(versionData == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR, System.Label.File_is_null));
            return null;
        }
        if(versionData.size() > IMAGE_MAX_SIZE){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR, System.Label.File_is_too_big));
            versionData = null;
            return null;
        }
        if(contentType != 'image/jpeg' && contentType != 'image/jpg' && contentType != 'image/png'){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR, System.Label.File_invalid_format));
            return null;
        }
        deletePreviousFiles();
        currentContentVersion = new ContentVersion(
            Title = title,
            PathOnClient = pathOnClient,
            VersionData = versionData,
            FirstPublishLocationId = thisCandidate.Id
        );
        try {
            insert currentContentVersion;
        } catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR, e.getMessage()));
        }
        return null;
    }
    
    public List<ContentVersion> getContentVersionList(){
        List<ContentVersion> contentVersionList = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE FirstPublishLocationId =: thisCandidate.Id];
        return contentVersionList;
    }
    
    public void deletePreviousFiles() {
        List<ContentVersion> contentVersionList = getContentVersionList();
        List<ContentDocument> contentDocumentList = new List <ContentDocument>();
        
        for(ContentVersion temporaryContentVersion : contentVersionList){
            try{
                ContentDocument thisContentDocument = [SELECT Id FROM ContentDocument WHERE Id =: temporaryContentVersion.ContentDocumentId];
           		contentDocumentList.add(thisContentDocument); 
            }catch(QueryException e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR, e.getMessage()));
            }
        }
        delete contentDocumentList;
    }
}