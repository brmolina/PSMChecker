@isTest
public class PSMCheckerControllerTest {
    @TestSetup
    static void createRecords(){
        TriggerBypass.setDoNotRunTrigger();
        	List<Contact> employee = ELC_Test_DataFactory.getContact1(1,true);
        	ELC_Test_DataFactory.getRelatedEmployee(1, true, employee[0].Id);

        Id linksRecordTypeId = Schema.SObjectType.ELC_MasterConfiguration__c.getRecordTypeInfosByName().get('Links').getRecordTypeId();
        Id topicsRecordTypeId = Schema.SObjectType.ELC_MasterConfiguration__c.getRecordTypeInfosByName().get('Topics').getRecordTypeId();
      
        List<ELC_MasterConfiguration__c> topics = ELC_Test_DataFactory.getTopics(1,true, topicsRecordTypeId);
        ELC_Test_DataFactory.getLinksWithTopics(10, true, linksRecordTypeId, topics[0].Id);
    }
    @isTest
    public static void testing(){
        List<ELC_Employee_Related_Information__c> relatedEmp = [
            			SELECT 
            				Name,
            				ELC_Employee__r.FirstName, 
                             ELC_Employee__r.LastName,
                             ELC_Employee__r.ELC_Correspondence_Language__c, 
                             ELC_Employee__r.ELC_Manager_Flag__c,
                             ELC_Employee__r.ELC_Additional_Privileges__c,
                             ELC_Job_Function__c,
                             ELC_Job_Sub_Function__c,
                             ELC_High_Level_Organization__c,
                             ELC_Job_Area__c,
                             ELC_Work_Location_Country__c,
                             ELC_Work_Location_State__c,
                             ELC_Work_Location_City__c,
                             ELC_Work_Location_Building_Name__c,
                             ELC_Work_Location_Type__c,
                             ELC_Global_Grade__c,
                             ELC_Brand_Non_Brand__c,
                             ELC_Function__c,
                             ELC_SubFunction__c,
                             ELC_Organization_Country_Region__c
                             FROM
                             ELC_Employee_Related_Information__c limit 1];
        ELC_Employee_Related_Information__c employee = relatedEmp[0];
        List <ELC_Employee_Related_Information__c> relEmployee = PSMCheckerController.getEmployeesByNumber(employee.Name);
        
        PSMCheckerController.searchPSM( 
            employee.ELC_Employee__r.ELC_Correspondence_Language__c, 
            employee.ELC_Employee__r.ELC_Manager_Flag__c,
            employee.ELC_Employee__r.ELC_Additional_Privileges__c,
            employee.ELC_Job_Function__c,
            employee.ELC_Job_Sub_Function__c,
            employee.ELC_High_Level_Organization__c,
            employee.ELC_Job_Area__c,
            employee.ELC_Work_Location_Country__c,
            employee.ELC_Work_Location_State__c,
            employee.ELC_Work_Location_City__c,
            employee.ELC_Work_Location_Building_Name__c,
            employee.ELC_Work_Location_Type__c,
            employee.ELC_Global_Grade__c,
            employee.ELC_Brand_Non_Brand__c,
            employee.ELC_Function__c,
            employee.ELC_SubFunction__c,
            employee.ELC_Organization_Country_Region__c
);
    }
}