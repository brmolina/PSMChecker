trigger ELC_Contact on Contact (before insert, before update, after insert, after update) {
  if (TriggerBypass.doNotBypassTrigger()){ //Bruno Molina 31/12/2021 for PSMCheck

    if(Label.User_Contact_Trigger_Is_Active.equalsIgnoreCase('false')) {
        return;
    }
   
    // Just check for one of the records to verify if we are updating the related-user
    // If the related-user is being updated, no need to execute the trigger again.
  //  if( (null != Trigger.old) && (Trigger.old[0].ELC_RelatedUser__c != Trigger.new[0].ELC_RelatedUser__c) ) {
        // Related user has changed. No need to execute further.
   //     return;
  //  }
    
    /*if(Trigger.isBefore) {
        MA_ContactHelper.UpdateDeFactoAndBusinessContacts(Trigger.Old, Trigger.New);
        MA_ContactHelper.updateAccountAndRecordType(Trigger.Old, Trigger.New);
        if(Trigger.isUpdate && Trigger.newMap != null){
          MA_ContactHelper.retainLanguagePreference(Trigger.oldMap, Trigger.newMap);
        }
    }*/
    if(Trigger.isBefore && Trigger.isUpdate) {
        ELC_ContactHelper.empEmailUpdate(Trigger.oldMap, Trigger.newMap);
    }
    if(Trigger.isAfter) {
        system.debug('Nishant trigger start');
        ELC_ContactHelper.updatePortalUser(Trigger.oldMap, Trigger.newMap);  
        ELC_ContactHelper.updateUserName(Trigger.newMap);
         //Krishna - Commented below method to stop Fed ID update to faciliate UAT Upgrade testing - June 01, 2020  
        ELC_ContactHelper.updateUserFedId(Trigger.newMap);
        ELC_ContactHelper.updateUserEmpNumFedId(Trigger.newMap);   

      } //Bruno Molina 31/12/2021 for PSMCheck
    }
}