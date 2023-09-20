public class LeadTriggerHandler extends TriggerHandler {

    private Map<Id, Lead> newLeadMap;

    public LeadTriggerHandler() {
        this.newLeadMap = (Map<Id, Lead>) Trigger.newMap;
    }

    public override void afterUpdate() {
        //
      }
}