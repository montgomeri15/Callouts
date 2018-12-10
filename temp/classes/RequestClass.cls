public class RequestClass {
    static String consumerKey = '3MVG9zlTNB8o8BA0XTN2CO6T58S141MYGoKwpPNaqqNeDih8dq05nznO1uhv0d_wri59hb1dhe1oqyTNKtg_m';
	static String consumerSecret = '3281958042781871073';
	static String username = 'yagamiraito765@gmail.com';
	static String password = 'mypassword1sOQZsZi0SDkBm8rAn2bRgzja';
    static String requestBody = 'grant_type=password&client_id=' + consumerKey +'&client_secret=' + consumerSecret +
        						'&username=' + username + '&password=' + password;
    
    public static HttpRequest createRequestForToken(String service){
        HttpRequest ourRequest = new HttpRequest();
        ourRequest.setBody(requestBody);
		ourRequest.setMethod(service);
    	ourRequest.setEndpoint('https://na59.salesforce.com/services/oauth2/token');
        return ourRequest;
    }
    
    public static HttpRequest createRequestForService(String token, String method, String endpoint){
		HttpRequest finalRequest = new HttpRequest();
        finalRequest.setHeader('Authorization','Bearer ' + token);
        finalRequest.setHeader('Content-Type','application/json');
        finalRequest.setHeader('accept','application/json');
  		finalRequest.setMethod(method);
        finalRequest.setEndpoint('https://na59.salesforce.com/services/apexrest/' + endpoint);
		return finalRequest;
	}
}