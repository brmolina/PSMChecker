@isTest
public class TrendingCheckerControllerTest {
    @TestSetup
    static void createRecords(){
        Id linksRecordTypeId = Schema.SObjectType.ELC_MasterConfiguration__c.getRecordTypeInfosByName().get('Links').getRecordTypeId();
        Id topicsRecordTypeId = Schema.SObjectType.ELC_MasterConfiguration__c.getRecordTypeInfosByName().get('Topics').getRecordTypeId();
        
        List<ELC_MasterConfiguration__c> topics = ELC_Test_DataFactory.getTopics(1,true, topicsRecordTypeId);
        ELC_Test_DataFactory.getLinksWithTopics(10, true, linksRecordTypeId, topics[0].Id);
    }
    
    @isTest
    public static void testing(){
        TrendingCheckerController.getLocations('uni');
        List<String> locations  = new List<String>();
            locations.add('\'United States\'');
         TrendingCheckerController.getJobFunction('sa', locations);
        TrendingCheckerController.getFunction('sa', locations);
        List<String> jobFunctions  = new List<String>();
            jobFunctions.add('\'Sales\'');
        List<String> functions  = new List<String>();
            functions.add('\'Field Sales\'');
        
        TrendingCheckerController.searchTrendingArticles(locations, jobFunctions, functions, false);
    }

}