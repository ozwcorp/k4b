public class K4BTriggerHandler extends TriggerHandler  {
    private Map<Id, K4B_Onboarding__c> newK4bMap;
    private Map<Id, K4B_Onboarding__c> oldK4bMap;

    public K4BTriggerHandler() {
        this.newK4bMap = (Map<Id, K4B_Onboarding__c>) Trigger.newMap;
        this.oldK4bMap = (Map<Id, K4B_Onboarding__c>) Trigger.OldMap;
    }

    public override void afterUpdate() {
        Map<Id,Lead> mapLeadbyK4bId = new Map<Id,Lead>();
        List<Id> leadIds = new List<Id>();
       List<Lead> leads = new List<Lead>();
       List<Lead> leadsToUpdate = new List<Lead>();
        for(K4B_Onboarding__c k4b :newK4bMap.values()){
            leadIds.add(k4b.Lead__c);
        }
        leads = LeadSelector.getK4BLeadByIds(leadIds);

        if(!leads.isEmpty()){
            for(Lead lead :leads){
                mapLeadbyK4bId.put(lead.K4B_Onboarding__c, lead);
            }

            for(K4B_Onboarding__c k4b :newK4bMap.values()){
                Lead lead = mapLeadbyK4bId.get(k4b.Id);
                if(k4b.Contact_Name__c != lead.LastName ||
                    k4b.Business_Email__c != lead.Company_Email__c ||
                    k4b.Contact_Email__c != lead.Email ||
                    k4b.Start_date__c != lead.Start_date__c ||
                    k4b.Planned_completion_date__c != lead.Planned_completion_date__c ||
                    k4b.Company_Name__c != lead.Company
                ){
                    lead.LastName = k4b.Contact_Name__c;
                    lead.Company_Email__c = k4b.Business_Email__c;
                    lead.Email = k4b.Contact_Email__c;
                    lead.Start_date__c = k4b.Start_date__c;
                    lead.Planned_completion_date__c = k4b.Planned_completion_date__c;
                    lead.Company = k4b.Company_Name__c;
                    leadsToUpdate.add(lead);
                }
            } 
            if(!leadsToUpdate.isEmpty()){
                update leadsToUpdate;
            }
        }
    }
}