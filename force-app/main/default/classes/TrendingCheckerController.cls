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
    public static List<String> getJobFunction(String jobFunction, List<String> location){
        System.debug('jobFunction passed ==> '+jobFunction);
        System.debug('location passed ==> '+location);

        String locationQuery = '\'All\'';
        if(location != null && location.size()>0){
            for(String loc: location){
                locationQuery = locationQuery + ','+loc;

            }
        }
        System.debug('locationQuery with All ==> '+locationQuery);
        
        List<String> jobFunctions = new List<String>();
        List<String> jobFunctionsList = new List<String>();
        List<String> locationsList = new List<String>();
        Set<String> jobFunctionsSet = new Set<String>();
        String databaseQuery = 'SELECT ELC_Job_Function__c, ELC_Location__c FROM ELC_MasterConfiguration__c WHERE ELC_Location__c INCLUDES ('+locationQuery+')';
        List<ELC_MasterConfiguration__c> jobFunctionMCList = Database.query(databaseQuery);
        //       List<ELC_MasterConfiguration__c> jobFunctionMCList= [SELECT ELC_Job_Function__c, ELC_Location__c FROM ELC_MasterConfiguration__c WHERE ELC_Location__c INCLUDES :locationsForQuery];
        System.debug('Job Function master configuration found in query ==> '+jobFunctionMCList);
        try {
            for(ELC_MasterConfiguration__c mc : jobFunctionMCList){
                if(mc.ELC_Job_Function__c != null){
                    jobFunctionsList = mc.ELC_Job_Function__c.split(';');
                }
                for(String s : jobFunctionsList){
                    if(s != null && s.containsIgnoreCase(jobFunction) /* || s.contains('All') */){
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
    @AuraEnabled
    public static List<String> getFunction(String function, List<String> location){
        System.debug('function passed ==> '+function);
        System.debug('location passed ==> '+location);
        
        String locationQuery = '\'All\'';
        if(location != null && location.size()>0){
            for(String loc: location){
                locationQuery = locationQuery + ','+loc;
                
            }
        }
        System.debug('locationQuery with All ==> '+locationQuery);
        
        List<String> functions = new List<String>();
        List<String> functionsList = new List<String>();
        Set<String> functionsSet = new Set<String>();
        String databaseQuery = 'SELECT ELC_Function__c, ELC_Location__c FROM ELC_MasterConfiguration__c WHERE ELC_Location__c INCLUDES ('+locationQuery+')';
        List<ELC_MasterConfiguration__c> functionMCList = Database.query(databaseQuery);
        System.debug('functionMCList ==> '+functionMCList);
        try {
            for(ELC_MasterConfiguration__c mc : functionMCList){
                if(mc.ELC_Function__c != null){
                    functionsList = mc.ELC_Function__c.split(';');
                }
                for(String s : functionsList){
                    if(s != null && s.containsIgnoreCase(function)/* || s.contains('All') */){
                        functionsSet.add(s);
                    }
                }
            }
            System.debug('functionsList ==> '+ functionsList);
            System.debug('functionsSet ==> '+ functionsSet);
            functions.addAll(functionsSet);
            System.debug('functions returned ==> '+ functions);
            return functions;
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<ELC_MasterConfiguration__c> searchTrendingArticles(List<String> locationItems, List<String> jobFunctionItems, List<String> functionItems, Boolean isInactive){
        try {
        System.debug('locationItems ==> '+locationItems);
        System.debug('jobFunctionItems ==> '+jobFunctionItems);
        System.debug('functionItems ==> '+functionItems);
        System.debug('isInactive ==> '+isInactive);

        List<ELC_MasterConfiguration__c> trendingArticlesList = new List<ELC_MasterConfiguration__c>();
            //treat location values
        String locationQuery = '\'All\'';
        if(locationItems != null && locationItems.size()>0){
            for(String loc: locationItems){
                locationQuery = locationQuery + ','+loc;
                
            }
        }
        System.debug('locationQuery with All ==> '+locationQuery);
            //treat jobFunctionItems values
        String jobFunctionQuery = '\'All\'';
        if(jobFunctionItems != null && jobFunctionItems.size()>0){
            for(String loc: jobFunctionItems){
                jobFunctionQuery = jobFunctionQuery + ','+loc;
                
            }
        }
        System.debug('jobFunctionQuery with All ==> '+jobFunctionQuery);
            //treat functionItems values
        String functionQuery = '\'All\'';
        if(functionItems != null && functionItems.size()>0){
            for(String loc: functionItems){
                functionQuery = functionQuery + ','+loc;
                
            }
        }
        System.debug('functionQuery with All ==> '+functionQuery);

        String databaseQuery = 'Select  Id, Name, ELC_Master_Configuration__r.ELC_Topic_Name__c, ELC_Master_Configuration__r.Name,'+
        ' ELC_Master_Configuration2__r.ELC_Sub_Topic_Name__c, ELC_Master_Configuration2__r.Name, ELC_Link_name__c, ELC_Location__c,'+
        ' ELC_Location_Type__c, ELC_Job_Function__c, ELC_Function__c, ELC_Hierarchy__c, ELC_Payroll__c, ELC_Correspondence_Language__c,'+
        ' Indicator__c, ELC_Brand__c,ELC_Additional_Privileges__c, ELC_Links__c, ELC_Links_Order__c, ELC_Link_keywords__c, ELC_Icon_Type__c,'+
        ' RecordType.Name, ELC_MC_External_ID_From_Dev__c'+
        ' FROM ELC_MasterConfiguration__c'+
        ' WHERE ELC_Inactive__c ='+ isInactive+
        ' AND RecordType.Name = \'Links\''+
        ' AND ELC_Location__c INCLUDES ('+locationQuery+')'+
        ' AND ELC_Job_Function__c INCLUDES ('+jobFunctionQuery+')'+
        ' AND ELC_Function__c INCLUDES ('+functionQuery+')'+
        ' AND ELC_Master_Configuration__r.ELC_Topic_Name__c = \'Trending on OneSource\'';

        trendingArticlesList = Database.query(databaseQuery);

        System.debug('TRENDING QUERY RESULT => '+trendingArticlesList);

            return trendingArticlesList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
