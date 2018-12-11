public class CalloutResumeRecordsForMock {
    
    public String photoCode = '/9j/4AAQSkZJRgABAQEAYABgAAD/2wBDABALDA4MChAODQ4SERATGCgaGBYWGDEjJR0oOjM9PDkzODdASFxOQERXRTc4UG1RV19iZ2hnPk1xeXBkeFxlZ2P/2wBDARESEhgVGC8aGi9jQjhCY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2P/wAARCAG2Af'
		+ 'QDASIAAhEBAxEB/8QAGwAAAgMBAQEAAAAAAAAAAAAAAAECAwQFBgf/xAAzEAACAgEEAQMDAgYCAgMBAAAAAQIRAwQSITFBBVFhEyJxgZEGFCMyobFCUhUzNMHh8f/EABgBAQEBAQEAAAAAAAAAAAAAAAABAgME/8QAHBEBAQEBAAMBAQAAAAAAAAAAAAERAgMSMSET/9oADAMBAAIRAxEAPwD3IABxdAAAAAAEAAAAAAAAA'
		+ 'AAAAABRKgo1IaiBOhUX1TUQJUIzi6QDEAiLJMTCq2VyLWVyCqJmbIjVNGaaKrNNFE4mqSKZxIsZJoqkjTOJTNEalZ2qItFsokGiNIEXZNoi0QQYmSaIsKiIkyLCkJjBRculZEKxNl0dLml1Bl0PTNRNf2tFw2MVhZ0V6NqGOXo2dIuVPZzLCzTk0GfH3AzShOPcWRdKwsXIgHYWKxWUSsVisTYErE2RsLAlYrI2FgSsTkRsi'
		+ '2A3ITmxNlbYRP6jAqbAi6+tAAG3nAAAAAAAAAEQAAAAAADSGkCJI6cxKKGAjfxkxBYWVQKhgZwRaE0TFRm8rqsTJNEWYxqIMrkWNEJIKqkiiaNEkUyRRnmimUTRJFckFZZxKZRNU0VTiRWSUSto0SiVSiTGtUtcEWi5og4hdVNEWi1oi0RdVtEseCeR1GNmnTaLJnkuODvaP0tQSbRc1L05Gm9IlPmSOvpvR8UFbSOnjwRgq'
		+ 'SLlE3OHO9suPRYoriKLlgiuooupDN+rneqpWKPsgeKPsi4VD1PasmXR45rlIw6j0mEouoo7NEXGyesWdV5DV+kbItpHGzYXjbTPf6rBGWN8HkvVMKhNmOucdeetcZkSc19zIGHQCsBUA7FYCALCxCAdisBMBMgyTISCIt8gJgB9dAAK84ABAMAAqgAAiAAAAAALBJEkyFjs6RMSIthYM0FY0IYDGKwsILCxAFJkWidCozYsq'
		+'//Z';
    
    public String getRecordsInString(){
        String records = '[';
        String forLoop;
        
        for(Integer i=0; i<999; i++){
            forLoop = '{"attributes":{"type":"Resume__c","url":"/services/data/v44.0/sobjects/Resume__c/a01f400000Mji'+ i +'AAB"},"First_Name__c":"Name","Last_Name__c":"Last","Age__c":25,'
            + '"Salary__c":3453,"Email__c":"test'+ i +'@gmail.com","Currently_Employed__c":false,"Photo_Code__c":"'+ photoCode +'","Photo_PathOnClient__c":"2015-'+ i +'-15_175403ya.jpg",'
            + '"Position_ID__c":"text someIdsIsHere a0A1r000'+ i +'xSkG2EAK"},';
            records += forLoop;
        }
        records += '{"attributes":{"type":"Resume__c","url":"/services/data/v44.0/sobjects/Resume__c/a01f400000Mji5uAAB"},"First_Name__c":"My","Last_Name__c":"Name","Age__c":28,'
            + '"Salary__c":5565,"Email__c":"montgomeri15@gmail.com","Currently_Employed__c":true,"Photo_Code__c":"'+ photoCode +'","Photo_PathOnClient__c":"2015-10-15_175403ya.jpg",'
            + '"Position_ID__c":"text 9 10 12 a0A1r00002xTAumEAG a0A1r00002xSkG2EAK"}]';
        return records;
    }

}
