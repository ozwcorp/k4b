public class LeadSelector {
    
    public static List<Lead> getK4BLeadByIds(List<Id> leadIds){
        List<Lead> leads = new List<Lead>();
        if(leadIds.isEmpty()){
            return leads;
        }
        leads = [SELECT Id,LastName,K4B_Onboarding__c,Company_Email__c,Company,Email,Start_date__c,Planned_completion_date__c FROM Lead WHERE Id IN :leadIds AND K4B_Onboarding__c != null];
        return leads;
    }

}