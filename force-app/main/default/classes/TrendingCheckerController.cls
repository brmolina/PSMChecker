/*
 * Date             : 25/01/2022
 * Created By       : Bruno Molina
 * Description:     : Custom LWC to filter Trending on OneSource Master Configuration records.
 * User Stories     : OSP-17769
 */
public class TrendingCheckerController {
    @AuraEnabled
    public static List<String> getLocations(String location){
       
        List<String> locations = new List<String>();
        List<String> locationsList = new List<String>();
        Set<String> locationsSet = new Set<String>();
        try {
            for(ELC_MasterConfiguration__c mc : [SELECT ELC_Location__c FROM ELC_MasterConfiguration__c ]){
                if(mc.ELC_Location__c != null){
                    locationsList = mc.ELC_Location__c.split(';');
                }
                for(String s : locationsList){
                    if(s != null && s.containsIgnoreCase(location)){
                        locationsSet.add(s);
                    }
                }
            }
            System.debug('locationsList ==> '+ locationsList);
            System.debug('locationsSet ==> '+ locationsSet);
            locations.addAll(locationsSet);
            System.debug('Locations returned ==> '+ locations);
            return locations;
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static List<String> getJobFunction(String jobFunction){
       
        List<String> jobFunctions = new List<String>();
        List<String> jobFunctionsList = new List<String>();
        Set<String> jobFunctionsSet = new Set<String>();
        try {
            for(ELC_MasterConfiguration__c mc : [SELECT ELC_Job_Function__c FROM ELC_MasterConfiguration__c ]){
                if(mc.ELC_Job_Function__c != null){
                    jobFunctionsList = mc.ELC_Job_Function__c.split(';');
                }
                for(String s : jobFunctionsList){
                    if(s != null && s.containsIgnoreCase(jobFunction)){
                        jobFunctionsSet.add(s);
                    }
                }
            }
            System.debug('jobFunctionsList ==> '+ jobFunctionsList);
            System.debug('jobFunctionsSet ==> '+ jobFunctionsSet);
            jobFunctions.addAll(jobFunctionsSet);
            System.debug('jobFunctions returned ==> '+ jobFunctions);
            return jobFunctions;
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
