@RestResource(urlMapping='/k4b/*')
global without sharing class K4BOnboardingRest {
    global K4BOnboardingRest() {

    }

    // Create a new records
    @HttpPost
    global static String createOnboarding() {
        List<String> saveSuccess = new List<String>();
        List<String> saveError = new List<String>();
        Result2Json result2Json = new Result2Json();

        // Initializing the request parameter with the incoming request
        RestRequest onboardingRequest = RestContext.request;
        // Getting the request body from the request
        String requestBody = onboardingRequest.requestBody.toString();

        List<K4B_Onboarding__c> k4bToCreate = (List<K4B_Onboarding__c>) JSON.deserialize(requestBody, List<K4B_Onboarding__c>.class);

        if(!k4bToCreate.isEmpty()){
            Database.SaveResult[] saveResult = Database.Insert(k4bToCreate, false);
                for(Integer i=0;i<saveResult.size();i++){
                if(!saveResult[i].isSuccess()){
                    String insertError = saveResult[i].getErrors()[0].getMessage();
                    saveError.add('Error: ' +insertError+ ' FailedRecord: ' +k4bToCreate[i]);
                }else{
                    saveSuccess.add(String.valueOf(k4bToCreate[i]));
                }
            }
        }
        // Return JSON success and error lists 
        return result2Json.convertToStringJson(saveSuccess, saveError);
    }

    // Update existing record(s)
    @HttpPut
    global static List<K4B_Onboarding__c> updateOnboarding() {
        // Initializing the request parameter with the incoming request
        RestRequest onboardingRequest = RestContext.request;
        // Getting the request body from the request
        String requestBody = onboardingRequest.requestBody.toString();

        List<K4B_Onboarding__c> k4bToUpdate= (List<K4B_Onboarding__c>) JSON.deserialize(requestBody, List<K4B_Onboarding__c>.class);

        if(!k4bToUpdate.isEmpty()){
            // Update the list of records
            update k4bToUpdate;
        }
        
        return k4bToUpdate;
    }

    // Delete existing record(s)
    @HttpDelete
    global static String deleteOnboarding() {
        RestRequest req = RestContext.request;
        List<String> recordIds = req.params.get('ids').split(',');
        
        List<K4B_Onboarding__c> recordsToDelete = [SELECT Id FROM K4B_Onboarding__c WHERE Id IN :recordIds];
        delete recordsToDelete;
        
        return 'Records deleted successfully';
    }

    // Retrieve existing records
    @HttpGet
    global static List<K4B_Onboarding__c> getOnboarding() {
        List<K4B_Onboarding__c> records = [SELECT Id, Name, Contact_Name__c, Onboarding_Type__c, Stage__c, 
                                            Start_Date__c, Planned_completion_date__c, Contact_Email__c, Business_Email__c 
                                            FROM K4B_Onboarding__c];
        return records;
    }

    public class Result2Json {

        public String convertToStringJson(List<String> successList, List<String> errorList) {
            Map<String, Object> resultMap = new Map<String, Object>();
            resultMap.put('Success', successList);
            resultMap.put('Error', errorList);
            
            String jsonString = JSON.serialize(resultMap);
            return jsonString;
        }
    }
}