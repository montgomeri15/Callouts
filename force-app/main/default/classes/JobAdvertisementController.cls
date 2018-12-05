public class JobAdvertisementController {
    
    public static Position__c position;
    public static CalloutJobAdvertisement calloutJobAdvertisement;
        
    public JobAdvertisementController(ApexPages.StandardController controller){
        position = (Position__c)controller.getRecord();
    }
    
    public static void CreateJobAdvertisement(){
        CalloutJobAdvertisement.postCalloutResponseContents(position.Id);
    }
    
    /*public static void CreateJobAdd(){
       if (CalloutJobAdvertisement.postCalloutResponseContents(position.Id)) {
           position.Site_Status__c='Posted';
       }else {
           position.Site_Status__c='Not Posted';
       }
       try{
           update position;
        }catch(Exception e){
        	system.debug('Exception message' + e);
        }
    }*/
    
      /*public void DeleteJobAdd(){
       if (JobApiRESTAPI.deleteDataUsingGet(position.Id)) {position.JobStatusBool__c='false';}
        else {position.JobStatusBool__c='true';}
        try{
            update position;
        }catch(Exception e){
        system.debug('Exception message'+e);
        }*/
    
}