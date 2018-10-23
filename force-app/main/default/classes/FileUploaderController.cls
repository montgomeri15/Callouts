public class FileUploaderController {
    
    public ContentVersion conVer {get; set;}
    public ContentDocumentLink conDocLink {get; set;}
    public Candidate__c thisCandidate{get; set;}
   
    public FileUploaderController(ApexPages.StandardController controller){
        thisCandidate = (Candidate__c)controller.getRecord();
        conVer = new ContentVersion();
    }

    public PageReference uploadFile() {
        List<ContentVersion> conVerList = new List<ContentVersion>();
        List<ContentDocumentLink> conDocLinkList = new List<ContentDocumentLink>();
        
        if (conVer.VersionData == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR, Label.Error_No_File));
            conVer.VersionData = null;
            return null;
        }
        
        /***  Блок для проверки расширения  ***/
        String path = conVer.PathOnClient;
        Set<String> acceptedExtensions = new Set<String> {'.jpeg', '.jpg', '.png', '.tiff', '.tif', '.bmp', '.jpe', '.jfif'};
        Boolean found = false;
      
        for(String ext : acceptedExtensions){
            if(found = path.endsWith(ext)){
                break;
            }   
        }
        if(!found){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR, Label.Error_Extension));
            conVer.VersionData = null;
            return null; 
        }
        /***  Конец блока  ***/
                
        conVerList.add(conVer);
        try {
            insert conVerList;              
        } catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR, e.getMessage()));
        }
        
        thisCandidate.Photo__c = conVer.Id;
        update thisCandidate;
        
        if (conVer.ContentDocumentId == null) {
            
            Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =: conVer.Id].ContentDocumentId;
            
            conDocLink = new ContentDocumentLink(
                LinkedEntityId = thisCandidate.Id,
                ContentDocumentId = conDoc,
                ShareType = 'I'
            );
            
            conDocLinkList.add(conDocLink);
            try {
            	insert conDocLinkList;
        	} catch(Exception e) {
            	ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR, e.getMessage()));
        	}
        } 
        conVer.VersionData = null;
        return null;
    }

    public PageReference deleteFile() {
        
        thisCandidate.Photo__c = null;
        
        try {
            update thisCandidate;
        } catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR, e.getMessage()));
        }
        conVer = new ContentVersion();
        return null;
    }
}