public class PositionButtonsController {
    
    public static Position__c position = [SELECT Id, Post_Status__c, Approval_Status__c, Status__c
                                   FROM Position__c
                                   WHERE Id =: ApexPages.CurrentPage().getparameters().get('Id')];
    public static String positionStatus{get;set;}
    public static String successResultMessage{get;set;}
    public static String errorResultMessage{get;set;}
    
    public PositionButtonsController(ApexPages.StandardController controller){
        positionStatus = position.Post_Status__c;
    }
    
    public static void postJobAdvertisement(){
        try{
            HttpResponse response = CalloutJobAdvertisement.postCalloutResponseContents(position.Id);
            position.Post_Status__c = 'Posted';
            update position;
            successResultMessage = System.Label.Post_JobAdv_Success_Result_Message;
        } catch(Exception e){
            errorResultMessage = e.getMessage();
            if(e.getMessage() == System.Label.Item_already_exists){
                position.Post_Status__c = 'Posted';
            	update position;
            }
        }
        positionStatus = position.Post_Status__c;
    }
    
    public static void deleteJobAdvertisement(){
        try{
            HttpResponse response = CalloutJobAdvertisement.deleteCalloutResponseContents(position.Id);
            position.Post_Status__c = 'Not posted';
            update position;
            successResultMessage = System.Label.Delete_JobAdv_Success_Result_Message;
        } catch(Exception e){
            errorResultMessage = e.getMessage();
            if(e.getMessage() == System.Label.Item_does_not_exists){
                position.Post_Status__c = 'Not posted';
            	update position;
            }
        }
        positionStatus = position.Post_Status__c;
    }
    
    public static void updateJobAdvertisement(){
        try{
            HttpResponse response = CalloutJobAdvertisement.putCalloutResponseContents(position.Id);
            successResultMessage = System.Label.Update_JobAdv_Success_Result_Message;
        } catch(Exception e){
            errorResultMessage = e.getMessage();
            if(e.getMessage() == System.Label.Item_does_not_exists){
                position.Post_Status__c = 'Not posted';
            	update position;
            }
        }
        positionStatus = position.Post_Status__c;
    }
}