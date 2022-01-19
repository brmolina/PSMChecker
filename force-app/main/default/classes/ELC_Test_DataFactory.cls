/****************************************************************************************
* Created By    :   Ajay B R
* Create Date   :   03/02/2017
* Description   :   Util class to setup test data for test classes
* Modification Log:
*-----------------------------------------------------------------------------
** Developer                Date          Description
** ----------------------------------------------------------------------------
** Ajay B R                 03/02/2017    Initial version.

*****************************************************************************************/
@isTest
public with sharing class ELC_Test_DataFactory{
    
    /************************************************************************************
* Method       :    test data setup method
* Description  :    create the custom setting data needed for PushNotificationTask trigger 
*************************************************************************************/
    @testSetup public static void setup() {
        Node_Triggers_Control__c objCustom = new Node_Triggers_Control__c();
        objCustom.HRC_Trigger__c = true;
        objCustom.Servicenow_Trigger__c = true;
        objCustom.Name = 'Trigger Controls';
        objCustom.Task_Trigger__c = true;
        objCustom.Taleo_Trigger__c  = true;
        insert objCustom;
        
    }
    
    
    /************************************************************************************
* Method       :    createCases
* Description  :    create a list of Case
*************************************************************************************/
    public static Integer tier = null;
    public static List<Case> createDraftComplexCases(String caseCategory, String caseSubCat, Integer total, Boolean insertRecords, 
                                                     Contact con, Id RecordTypeId) {
                                                         List<Case> caseList = new List<Case>();
                                                         
                                                         for(Integer i = 0; i < total; i++){
                                                             caseList.add(new Case(
                                                                 ELC_Category__c   = caseCategory,
                                                                 ELC_SubCategory__c= caseSubCat,
                                                                 ContactId = con.Id,
                                                                 Status = 'New',
                                                                 RecordTypeId = RecordTypeId,
                                                                 ELC_SubStatus__c = 'Draft',
                                                                 Origin = 'Portal',
                                                                 ELC_AgreedToTerms__c=true,
                                                                 ELC_ProjectName__c = 'Regulatory Test Case from Console', ELC_Case_Number_Text__c='CN-12345', Subject='Test',//@saipriya added casenumber 6/21/2019
                                                                 Type='Problem'));
                                                         }
                                                         if(insertRecords){
                                                             insert caseList;
                                                         }
                                                         return caseList;
                                                     }
    
    /************************************************************************************
* Author       :    Nishit Babaria 
* Method       :    createApprovalCases
* Description  :    create a list of Cases for approvals
*************************************************************************************/
    public static List<Case> createApprovalCases(String caseCategory, String caseSubCat, Integer total, Boolean insertRecords, Contact con, Id RecordTypeId, String assNumber) {
        List<Case> caseList = new List<Case>();
        for(Integer i = 0; i < total; i++){
            caseList.add(new Case(
                ELC_Category__c   = caseCategory,
                ELC_SubCategory__c= caseSubCat,
                ContactId = con.Id,
                Status = 'New',
                RecordTypeId = RecordTypeId,
                ELC_SubStatus__c = 'Draft Reviewed',
                Origin = 'Portal',
                //ELC_Assignment_Number__c = assNumber,
                ELC_Action_on_Assignment__c='Add',
                ELC_ApprovalLevel__c = 1,
                ELC_Employee2__c = con.Id
            ));
        }
        if(insertRecords){
            insert caseList;
        }
        return caseList;
    }
    
    //Start OSP-6216 @saipriya
    public static List<Case> createApprovalCases1(String caseCategory, String caseSubCat, Integer total, Boolean insertRecords, Contact con, Id RecordTypeId) {
        List<Case> caseList = new List<Case>();
        for(Integer i = 0; i < total; i++){
            caseList.add(new Case(
                ELC_Category__c   = caseCategory,
                ELC_SubCategory__c= caseSubCat,
                ContactId = con.Id,
                Status = 'New',
                RecordTypeId = RecordTypeId,
                ELC_SubStatus__c = 'Draft Reviewed',
                Origin = 'Portal',
                //ELC_Assignment_Number__c = assNumber,
                ELC_ApprovalLevel__c = 1,

                ELC_Employee2__c = con.Id
            ));
        }
        if(insertRecords){
            insert caseList;
        }
        return caseList;
    }
    public static List<Contact> getContact1(Integer total, Boolean insertRecords){
        
        // Create Contact
        List<Contact> contacts = new List<Contact>();
        for(Integer i = 1; i <= total; i++){
            Contact con = new Contact( FirstName = 'Ricky' + i,
                                      LastName = 'Doe'+i,
                                      Email = 'ricky.doe'+i+ '@test.com',
                                      ELC_Additional_Privileges__c = 'HR Contact', //Bruno Molina for PSM Check 31/12/2021
                                      ELC_Correspondence_Language__c ='American English', //Bruno Molina for PSM Check 31/12/2021
                                      ELC_Terminated_Date__c = Date.today().addDays(10),
                                      ELC_RelatedUser__c = UserInfo.getUserId(),
                                      ELC_Candidate_ID__c = String.valueOf(Integer.valueOf(math.rint(math.random()*1000000))),
                                      ELC_Work_Location_Country__c = 'Belgium',
                                      ELC_Employee_Number__c = '2525'+i,
                                      ELC_Display_Name__c = 'Ricky Doe'+i,
                                      ELC_National_Identifier__c = '2525'+i,
                                      ELC_National_Identifier_Type__c = 'Social Insurance Number',
                                      ELC_Date_of_Birth_DD_MMM__c = '25-DEC',
                                      ELC_Manager_Flag__c = true,
                                      ELC_Person_Type__c = 'Employee',
                                      ELC_Latest_Start_Date__c = System.today() - 500,
                                      ELC_Personal_Email__c = 'ricky.doe'+i+ '@test.com'
                                     );
            contacts.add(con);
        }
        
        if(insertRecords){
            insert contacts;
            return contacts;
        }
        else
            return contacts;
    } 
    //End OSP-6216 @saipriya
    
    /*
* @Author : Prateek
* @description: Get Contacts based value and if wants to create contact
*/
    public static List<Contact> getContact(Integer total, Boolean insertRecords){
        
        // Create Contact
        List<Contact> contacts = new List<Contact>();
        for(Integer i = 1; i <= total; i++){
            Contact con = new Contact( FirstName = 'Ricky' + i,
                                      LastName = 'Doe'+i,
                                      Email = 'ricky.doe'+i+ '@test.com',
                                      ELC_Terminated_Date__c = Date.today().addDays(10),
                                      ELC_RelatedUser__c = UserInfo.getUserId(),
                                      ELC_Candidate_ID__c = String.valueOf(Integer.valueOf(math.rint(math.random()*1000000))),
                                      ELC_Work_Location_Country__c = 'Belgium',//OSP-6216 @saipriya added Work Location country
                                      ELC_Employee_Number__c = '2525'+i,
                                      ELC_Display_Name__c = 'Ricky Doe'+i,
                                      ELC_National_Identifier__c = '2525'+i,
                                      ELC_National_Identifier_Type__c = 'Social Insurance Number',
                                      ELC_Date_of_Birth_DD_MMM__c = '25-DEC',
                                      ELC_Manager_Flag__c = true,
                                      ELC_Person_Type__c = 'Employee',
                                      ELC_Latest_Start_Date__c = System.today() - 500,
                                      ELC_Personal_Email__c = 'ricky.doe'+i+ '@test.com'
                                     );
            contacts.add(con);
        }
        
        if(insertRecords){
            insert contacts;
            return contacts;
        }
        else
            return contacts;
    } 
    
    public static List<Contact> getContactWithPersonalEmail(Integer total, Boolean insertRecords){
        // Create Contact
        List<Contact> contacts = new List<Contact>();
        for(Integer i = 1; i <= total; i++){
            Contact con = new Contact(FirstName = 'Ricky' + i,
                                      LastName = 'Doe'+i,
                                      ELC_Personal_Email__c = 'mike.harford'+i + '@test.com',
                                      ELC_Terminated_Date__c = Date.today().addDays(10),
                                      ELC_RelatedUser__c = UserInfo.getUserId(),
                                      ELC_Candidate_ID__c = String.valueOf(Integer.valueOf(math.rint(math.random()*1000000))));
            contacts.add(con);
        }
        
        if(insertRecords){
            insert contacts;
            return contacts;
        }
        else
            return contacts;
    }
    
    /*
* @Author : Prateek
* @description: Pass -ve Integer value to get "OverDue Date Task"
*/
    public static List<Task> getOverDueDateTask(Integer day, Id taskRTId, Case c){
        Task t = new Task(Subject = 'Create Task-1 to update Section',
                          recordTypeId = taskRTId,
                          Status = 'Open',
                          Priority = 'Normal',
                          Description = 'Create Task to update Section',
                          ActivityDate = Date.today().addDays(day), // day should be -ve
                          WhatId = c.Id,
                          OwnerId = UserInfo.getUserId());
        
        List<Task> tasks = new List<Task>{t};
            try{
                insert tasks;
            }catch(Exception e){
                System.debug('Exception while creating Portal User :: '+e);
            }
        return tasks;
    }
    
    /*
* @Author : Prateek
* @description: Pass +ve Integer value to get "Due Date Task"
* @param: Integer, Id, Case
* @return Type: List<Task>
*/
    public static List<Task> getDueDateTask(Integer day, Id taskRTId, Case c, String status){
        List<Task> ntaskList = new List<Task>();
        for(Integer i=0; i<5; i++){
            Task nt = new Task(Subject = 'Create Task-'+i+' to update Section',
                               recordTypeId = taskRTId,
                               Status = status,
                               Priority = 'Normal',
                               Description = 'Create Task to update Section',
                               ActivityDate = Date.today().addDays(day), // day should be +ve
                               WhatId = c.Id,
                               OwnerId = UserInfo.getUserId());
            ntaskList.add(nt);
        }
        try{
            insert ntaskList;
        }catch(Exception e){
            system.debug('Exception' +e);
        }
        
        return ntaskList;
    }
    
    public static ELC_IntegrationLog__c getIntegrationLog(Id caseId){
        ELC_IntegrationLog__c intLog = new ELC_IntegrationLog__c();
        intLog.ELC_Case__c = caseId;
        intLog.OwnerId = UserInfo.getUserId();
        insert intLog;
        return intLog;
    }
    
    public static List<Case> createComplexCases(String caseCategory, String caseSubCat, Integer total, Boolean insertRecords, Contact con, Id RecordTypeId, Id userId) {
        List<Case> caseList = new List<Case>();
        
        if(caseCategory =='Job Data Change' && caseSubCat=='Data Correction' ){
            for(Integer i = 0; i < total; i++){
                caseList.add(new Case(
                    ELC_Category__c   = caseCategory,
                    ELC_SubCategory__c= caseSubCat,
                    ContactId = con.Id,
                    Status = 'New',
                    RecordTypeId = RecordTypeId,
                    ELC_SubStatus__c = 'Request Submitted',
                    Origin = 'Portal',
                    OwnerId = userId,
                    Subject = 'Some Subject',
                    ELC_AgreedToTerms__c=true,
                    ELC_ProjectName__c = 'Regulatory Test Case from Console',
                    ELC_Receipt_Date__c = System.Today(), ELC_Case_Number_Text__c='CN-12345',//@saipriya added casenumber 6/21/2019
                    ELC_Assignment_Number__c= '1234567890'
                ));
            } 
        } 
        //Start OSP-6216 @saipriya
        else if(caseCategory =='Job Data Change' && caseSubCat=='Merit Update' ){
            for(Integer i = 0; i < total; i++){
                caseList.add(new Case(
                    ELC_Category__c   = caseCategory,
                    ELC_SubCategory__c= caseSubCat,
                    ContactId = con.Id,
                    Status = 'New',
                    RecordTypeId = RecordTypeId,
                    ELC_SubStatus__c = 'Request Submitted',
                    Origin = 'Portal',
                    OwnerId = userId,
                    Subject = 'Some Subject',
                    ELC_AgreedToTerms__c=true,
                    ELC_Employee2__c = con.Id,
                    ELC_Effective_Date__c = Date.newInstance(2020, 4, 27),
                	ELC_Case_Expiration_Date__c = Date.newInstance(2019, 12, 9),
                    ELC_Assignment_Number__c= '-9'
                ));
            } 
        }
        else if(caseCategory =='Job Data Change' && caseSubCat=='Retro Job Data Change' ){
            for(Integer i = 0; i < total; i++){
                caseList.add(new Case(
                    ELC_Category__c   = caseCategory,
                    ELC_SubCategory__c= caseSubCat,
                    ContactId = con.Id,
                    Status = 'New',
                    RecordTypeId = RecordTypeId,
                    ELC_SubStatus__c = 'Request Submitted',
                    Origin = 'Portal',
                    OwnerId = userId,
                    Subject = 'Some Subject',
                    //ELC_AgreedToTerms__c=true,
                    ELC_Employee2__c = con.Id,
                    ELC_Effective_Date__c = Date.newInstance(2020, 4, 27),
                	//ELC_Case_Expiration_Date__c = Date.newInstance(2019, 12, 9),
                    ELC_Assignment_Number__c= '-9'
                ));
            } 
        }
        //End OSP-6216 @saipriya
        else {
            for(Integer i = 0; i < total; i++){
                caseList.add(new Case(
                    ELC_Category__c   = caseCategory,
                    ELC_SubCategory__c= caseSubCat,
                    ContactId = con.Id,
                    Status = 'New',
                    RecordTypeId = RecordTypeId,
                    ELC_SubStatus__c = 'Request Submitted',
                    Origin = 'Portal',
                    OwnerId = userId,
                    Subject = 'Some Subject',
                    ELC_AgreedToTerms__c=true,
                    ELC_ProjectName__c = 'Regulatory Test Case from Console', ELC_Case_Number_Text__c='CN-12345',//@saipriya added casenumber 6/21/2019
                    ELC_Receipt_Date__c = System.Today()
                )); 
            }
        }
        if(insertRecords){
            insert caseList;
        }
        return caseList;
    }
    
    /*
* @Author : Prateek
* @description: Create Single Portal User 
*/
    public static User createPortalUser(){
        String portalEmp = 'Portal Employee';
        Profile p = [SELECT Id FROM Profile WHERE Name = :portalEmp];
        
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        
        // create user
        User u = new User(  firstname = 'John',
                          lastName = 'Doe',
                          email = uniqueName + '@test' + orgId + '.org',
                          Username = uniqueName + '@test' + orgId + '.org',
                          EmailEncodingKey = 'ISO-8859-1',
                          Alias = uniqueName.substring(18, 23),
                          TimeZoneSidKey = 'America/Los_Angeles',
                          LocaleSidKey = 'en_US',
                          isActive = true,
                          LanguageLocaleKey = 'en_US',
                          EmployeeNumber = '25251',
                          ProfileId = p.Id);
        
        try{
            insert u;
        }catch(Exception e){
            System.debug('Exception while creating Portal User :: '+e);
        }
        return u;
    }
    
    
    /*
* @Author : Prateek
* @description: Create Service Information 1 records
*/
    public static List<ELC_Service_Information__c> createSerInfo1(Integer total, Boolean insertRecords, List<Case> cases, Id userId){
        
        List<ELC_Service_Information__c> serInfo1Lst = new List<ELC_Service_Information__c>();
        for(Integer i = 0; i < total; i++){
            ELC_Service_Information__c servInfo = new ELC_Service_Information__c(
                ELC_Case__c = cases[i].Id,
                ELC_Complainant_Name__c = 'Complainant Name', // Added by Tania : 5/6
                OwnerId = userId
            );
            serInfo1Lst.add(servInfo);
        }
        
        if(insertRecords){
            insert serInfo1Lst;
            return serInfo1Lst;
        }
        else
            return serInfo1Lst;
    }
    
    /*
* @Author : Prateek
* @description: Create Service Information 2 records
*/
    public static List<ELC_Service_Information_2__c> createSerInfo2(Integer total, Boolean insertRecords, List<Case> cases, Id userId){
        
        List<ELC_Service_Information_2__c> serInfo2Lst = new List<ELC_Service_Information_2__c>();
        for(Integer i = 0; i < total; i++){
            ELC_Service_Information_2__c servInfo2 = new ELC_Service_Information_2__c(
                ELC_Case__c = cases[i].Id,
                OwnerId = userId
            );
            serInfo2Lst.add(servInfo2);
        }
        
        if(insertRecords){
            insert serInfo2Lst;
            return serInfo2Lst;
        }
        else
            return serInfo2Lst;
    }
    
    public static List<ELC_MasterConfiguration__c> getMCSections(Integer total, Boolean insertRecords,Id sectionId, String category, String subCategory){
        List<ELC_MasterConfiguration__c> sections = new List<ELC_MasterConfiguration__c>();
        for(Integer i = 0; i < total; i++){
            ELC_MasterConfiguration__c section = new ELC_MasterConfiguration__c(
                ELC_Type__c = 'Master',
                RecordTypeId = sectionId,
                ELC_CaseRecordType__c = 'ELC_Legal',
                ELC_CaseCategory__c = category,
                ELC_CaseSubCategory__c = subCategory,
                ELC_Service_Information_Object_API__c = 'ELC_Service_Information__c',
                //ELC_ServiceType__c='Goods',
                ELC_Inactive__c= false,
                ELC_Object__c = 'Case',
                
                ELC_DefaultValue__c = 'default',
                ELC_HiddenOnCaseDetail__c= false,
                ELC_HiddenOnEditCase__c= false,
                ELC_Universal_Section_Flag__c = true,
                ELC_MC_External_ID_From_Dev__c =Math.random()+'g8'+String.valueOf(System.now().getTime()) );
            sections.add(section);
        }
        if(insertRecords){
            insert sections;
        }
        return sections;
    }
    
    //Added By Prateek
    public static List<ELC_MasterConfiguration__c> getWizardPageMCSections(Integer total, Boolean insertRecords,
                                                                           Id sectionId, String category, String subCategory, Id wizPageId, String recordTypeName){
                                                                               List<ELC_MasterConfiguration__c> sections = new List<ELC_MasterConfiguration__c>();
                                                                               for(Integer i = 0; i < total; i++){
                                                                                   ELC_MasterConfiguration__c section = new ELC_MasterConfiguration__c(
                                                                                       ELC_Type__c = 'Master',
                                                                                       RecordTypeId = sectionId,
                                                                                       ELC_CaseCategory__c = category,
                                                                                       ELC_CaseSubCategory__c = subCategory,
                                                                                       ELC_CaseRecordType__c = recordTypeName,
                                                                                       ELC_Service_Information_Object_API__c = 'ELC_Service_Information__c',
                                                                                       ELC_ServiceType__c='Service',
                                                                                       
                                                                                       ELC_Inactive__c= false,
                                                                                       ELC_Object__c = 'Case',
                                                                                       ELC_DefaultValue__c = 'default',
                                                                                       ELC_HiddenOnCaseDetail__c= false,
                                                                                       ELC_HiddenOnEditCase__c= false,
                                                                                       ELC_Wizard_Page__c = wizPageId,
                                                                                       ELC_Universal_Section_Flag__c = true,
                                                                                       ELC_MC_External_ID_From_Dev__c ='g9'+String.valueOf(System.now().getTime())+i+Math.random());
                                                                                   sections.add(section);
                                                                               }
                                                                               if(insertRecords){
                                                                                   insert sections;
                                                                               }
                                                                               return sections;
                                                                           }
    
    
    public static List<Account> getAccounts(Integer total, Boolean insertRecords){
        List<Account> accounts = new List<Account>();
        for(Integer i = 0; i < total; i++){
            Account a = new Account(Name = 'Sample Account',
                                    ELC_Account_External_ID__c = 'Ext'+i,
                                    Account_Status__c='Active');
            accounts.add(a);
        }
        if(insertRecords){
            insert accounts;
            return accounts;
        }else
            return accounts;
    }
    
    public static Entitlement getEntitlement(String ename, List<Account> accounts, Id entProcessId){
       //Start : Fix Business hrs Id null issue : Jun-19-2020
        Id businessHoursId = [SELECT Id FROM BusinessHours 
                                   WHERE Name LIKE '%ELC Legal SLA Hours%' AND IsActive = true limit 1].Id;
        system.debug('Business Hours Id'+businessHoursId);
        set<string> businessHrNames = new set<string>();
        businessHrNames.add('ELC Legal SLA Hours');
	    BusinessDayUtil.calculateMinutes(businessHrNames);
        //End : Fix Business hrs Id null issue : Jun-19-2020
        Entitlement entl = new Entitlement(Name = ename,
                                           AccountId =accounts[0].Id,
                                           SLAProcessId = entProcessId, 
                                           Type= 'Web Support',BusinessHoursId = businessHoursId);
        insert entl;
        return entl;
    }
    
    public static List<Case> getEntitlementCases(String category, String subCategory,Id contactId, Id recordTypeId,
                                                 Integer day, Id entitlementId,Boolean insertRecords, Integer total, String subStatus){
                                                     List<Case> cases = new List<Case>();
                                                     for(Integer i = 0; i < total; i++){
                                                         Case c = new Case(ELC_Category__c = category,
                                                                           ELC_SubCategory__c = subCategory,
                                                                           ContactId = contactId, Origin = 'Portal',
                                                                           Status = 'New', ELC_SubStatus__c = subStatus,
                                                                           ELC_AgreedToTerms__c = true,
                                                                           RecordTypeId = recordTypeId,
                                                                           EntitlementId = entitlementId, 
                                                                           ELC_Portal_Due_Date__c = Date.today().addDays(day));
                                                         cases.add(c);
                                                     }
                                                     
                                                     if(insertRecords){
                                                         insert cases;
                                                         return cases;
                                                     }else
                                                         return cases;
                                                 }
    
    // Added by Tania
    public static Id getRecordType(String ObjectName,string DevName){
        
        RecordType recordTypes = new RecordType();
        recordTypes = [SELECT Id,
                       DeveloperName 
                       FROM RecordType 
                       WHERE SobjectType = :ObjectName
                       AND DeveloperName = :DevName
                       LIMIT 1];
        
        return recordTypes.Id;                        
    }
    
    // Added by Tania
    public static List<ELC_MasterConfiguration__c> createWizardPages(Integer total, Boolean insertRecords, Id wizPageId, String caseSubCategory, String description)
    {
        List<ELC_MasterConfiguration__c> pages = new List<ELC_MasterConfiguration__c>();
        
        for(Integer i = 1; i <= total; i++)
        {
            ELC_MasterConfiguration__c page = new ELC_MasterConfiguration__c( recordTypeId= wizPageId,
                                                                             ELC_Wizard_Page_Name__c = caseSubCategory + i,
                                                                             ELC_Page_Order__c = i,
                                                                             ELC_Wizard_Page_Description__c = description,
                                                                             ELC_MC_External_ID_From_Dev__c =Math.Random()+'g1'+String.valueOf(System.now().getTime())+i);
            pages.add(page);
        }
        
        if(insertRecords)
        {
            insert pages;
            return pages;
        }
        else
            return pages;
    }
    
    // Added by Tania
    public static ELC_MasterConfiguration__c createMCSections(String category, String subCategory, Integer secOrder, String caseRT, String sectionLabel, String columns, String objectName, String sectionType, Boolean isUniversal, String portalLabel, String caseCategory, String caseSubCategory, String serviceObject, String serviceType)
    {
        Id sectionRT = getRecordType('ELC_MasterConfiguration__c','ELC_Section');
        
        ELC_MasterConfiguration__c section = new ELC_MasterConfiguration__c( RecordTypeId = sectionRT,
                                                                            ELC_CaseRecordType__c = caseRT,
                                                                            ELC_Section_Label__c = sectionLabel,
                                                                            ELC_OrderOfSection__c = secOrder,
                                                                            ELC_ColumnsPerSection__c = columns,
                                                                            ELC_Object__c = objectName,
                                                                            ELC_Type__c = sectionType,
                                                                            
                                                                            ELC_Universal_Section_Flag__c = isUniversal,
                                                                            ELC_Case_Category_Portal__c = category,
                                                                            ELC_Case_Sub_Category_Portal__c = subCategory,
                                                                            ELC_Related_List_Name_Portal__c = portalLabel,
                                                                            ELC_CaseCategory__c = caseCategory,
                                                                            ELC_CaseSubCategory__c = caseSubCategory,
                                                                            ELC_Service_Information_Object_API__c = serviceObject,
                                                                            ELC_ServiceType__c = serviceType,
                                                                            ELC_MC_External_ID_From_Dev__c =Math.Random()+'g2'+String.valueOf(System.now().getTime())
                                                                           );
        return section;
    }
    
    // Added by Tania
    // Added by Tania : 5/6 : "field order" as param
    public static ELC_MasterConfiguration__c createMCFields(String fieldLabel, String fieldAPI, String objName, String category, String subCategory, Boolean requiredNew, Boolean requiredEdit, String defaultValue, Integer fieldOrder)
    {
        Id fieldRT = getRecordType('ELC_MasterConfiguration__c','ELC_Fields');
        
        ELC_MasterConfiguration__c field = new ELC_MasterConfiguration__c( RecordTypeId = fieldRT,
                                                                          ELC_FieldLabel__c = fieldLabel,
                                                                          ELC_FieldNameAPI__c = fieldAPI,
                                                                          ELC_Object__c = objName,
                                                                          ELC_Case_Category_Portal__c = category,
                                                                          ELC_Case_Sub_Category_Portal__c = subCategory,
                                                                          ELC_Portal__c = true,
                                                                          ELC_Required_on_New_Page_Portal__c = requiredNew,
                                                                          ELC_Required_on_Edit_Page_Portal__c = requiredEdit,
                                                                          ELC_DefaultValue__c = defaultValue,
                                                                          ELC_MC_External_ID_From_Dev__c =Math.random()+'g4'+String.valueOf(System.now().getTime()),
                                                                          ELC_OrderOfField__c = fieldOrder // Added by Tania : 5/6
                                                                          //ELC_User_Location__c = 'All'       //Abhishek@Infosys(28-Nov-2018) : Added for new field
                                                                         );
        return field;
    }
    
    
    // Added by Tania : 14/6
    public static List<ELC_Service_Information__c> createRL(Integer total, Id CaseId, String serviceType)
    {
        List<ELC_Service_Information__c> serInfo1Lst = new List<ELC_Service_Information__c>();
        
        for(Integer i = 0; i < total; i++)
        {
            ELC_Service_Information__c servInfo = new ELC_Service_Information__c(
                ELC_Case__c = CaseId,
                ELC_NameOfImportantParty__c = 'LLC'+i,
                ELC_Type__c = serviceType
            );
            serInfo1Lst.add(servInfo);
        }
        
        insert serInfo1Lst;
        return serInfo1Lst;
    }
    
    
    // Added by Tania : 14/6
    public static Task createPortalTask(Id taskRTId, Id caseId, String selectedSection)
    {
        List<Task> ntaskList = new List<Task>();
        
        Task newTask = new Task(Subject = 'Portal Task',
                                RecordTypeId = taskRTId,
                                Status = 'Open',
                                Priority = 'Normal',
                                Description = 'Create Task to update complex case',
                                ActivityDate = Date.today()+10,
                                WhatId = CaseId,
                                ELC_Case_Sections_Selected__c = selectedSection
                               );
        
        try{
            insert newTask; 
        }catch(Exception e){
            system.debug('Exception' +e);
        }
        return newTask;
    }
    
    
    // Added by Tania : 14/6
    public static ELC_IntegrationLog__c createIntegrationLog()
    {
        ELC_IntegrationLog__c intLog = new ELC_IntegrationLog__c();
        insert intLog;
        return intLog;
    }
    
    
    public static List<CaseShare> createCaseShare(Integer total,Boolean insertRecords, List<Case> cases, Id userId){
        List<CaseShare> cShareLst = new List<CaseShare>();
        for(Integer i = 0; i < total; i++){
            cShareLst.add(new CaseShare(CaseAccessLevel = 'Edit',
                                        RowCause = 'Manual',
                                        caseId = cases[0].Id,
                                        UserOrGroupId = userId));
        }
        if(insertRecords){
            insert cShareLst;
        }
        return cShareLst;
    }
    
    
    public static Contact createContact(String fName, String lName, String email, Id userId){
        Contact con = new Contact(FirstName = fName, 
                                  LastName = lName,
                                  ELC_Preferred_Name__c = 'Test',
                                  ELC_Position_Title__c = 'MAC Artist',
                                  Email = email,
                                  ELC_Personal_Email__c = 'abc.abc@estee.com',
                                  ELC_RelatedUser__c = userId);
        insert con;
        return con;
    }
    
    public static List<Case> createConsoleCase(Integer total, Boolean insertRecords, String category,
                                               String subCategory, Id contactId, Id recordTypeId){
                                                   List<Case> cases = new List<Case>();
                                                   for(Integer i = 0; i < total; i++){
                                                       cases.add(new Case(ELC_Category__c = category,
                                                                          ELC_SubCategory__c = subCategory,
                                                                          ContactId = contactId,
                                                                          recordTypeId = recordTypeId,
                                                                          ELC_AgreedToTerms__c = true));
                                                   }
                                                   if(insertRecords){
                                                       insert cases;
                                                   }
                                                   return cases;
                                               }
    
    public static List<ELC_Master_Data__c> getMasterData(Integer total, Boolean insertRecords, String name, Id recordTypeId){
        List<ELC_Master_Data__c> masterDatas = new List<ELC_Master_Data__c>();
        for(Integer i = 0; i < total; i++){
            masterDatas.add(new ELC_Master_Data__c(Name = name, RecordTypeId = recordTypeId));
        }
        if(insertRecords){
            insert masterDatas;
        }
        return masterDatas;
    }
    
    
    // Added By Prateek
    public static List<ELC_MasterConfiguration__c> getTopics(Integer total, Boolean insertRecords, Id topicRTId){
        List<ELC_MasterConfiguration__c> topics = new List<ELC_MasterConfiguration__c>();
        for(Integer i = 0; i < total; i++){
            topics.add(new ELC_MasterConfiguration__c(ELC_Component__c = 'Header Footer Page',
                                                      recordTypeId = topicRTId,
                                                      ELC_Topic_Name__c = 'My Team',
                                                      ELC_Inactive__c = false, //Bruno Molina for PSM Check 31/12/2021
                                                      ELC_MC_External_ID_From_Dev__c ='g5'+String.valueOf(System.now().getTime())+i+Math.random(),
                                                      ELC_URL__c = '/apex/ELC_OS_Portal_LinksDetails?topic=My Team',
                                                      ELC_Order__c = 1));
        }
        if(insertRecords){
            insert topics;
        }
        return topics;
    }
    
    
    // Added By Prateek
    public static List<ELC_MasterConfiguration__c> getSubTopics(Integer total, Boolean insertRecords, 
                                                                Id subtopicRTId, Id topicRTId){
                                                                    List<ELC_MasterConfiguration__c> topics = new List<ELC_MasterConfiguration__c>();
                                                                    for(Integer i = 0; i < total; i++){
                                                                        topics.add(new ELC_MasterConfiguration__c(ELC_Sub_Topic_Name__c = 'Build My Team',
                                                                                                                  ELC_MC_External_ID_From_Dev__c =i+Math.random()+'getSubTopics'+String.valueOf(System.now().getTime()),
                                                                                                                  recordTypeId = subtopicRTId,
                                                                                                                  ELC_PSM_Description__c = 'Test',
                                                                                                                  ELC_Master_Configuration3__c = topicRTId));
                                                                    }
                                                                    if(insertRecords){
                                                                        insert topics;
                                                                    }
                                                                    return topics;
                                                                }
    
    
    // Added By Prateek
    public static List<ELC_MasterConfiguration__c> getLinks(Integer total, Boolean insertRecords, Id linkRTId, Id subtopicRTId){
        List<ELC_MasterConfiguration__c> topics = new List<ELC_MasterConfiguration__c>();
        for(Integer i = 0; i < total; i++){
            topics.add(new ELC_MasterConfiguration__c(ELC_Link_name__c = 'Test',
                                                      recordTypeId = linkRTId,
                                                      ELC_Master_Configuration2__c = subtopicRTId,
                                                      ELC_Topic_Name__c = 'My Team',
                                                      ELC_PSM_Description__c = 'Test',
                                                      ELC_Start_Date__c = Date.valueOf(system.now()),
                                                      ELC_Links__c = 'Category=New Hire;PreScreen=true;',
                                                      ELC_Job_Function__c = 'All',
                                                      ELC_Brand__c = 'All',
                                                      ELC_Location__c = 'All',
                                                      ELC_Location_Type__c = 'All',
                                                      ELC_MC_External_ID_From_Dev__c ='getLinks' +String.valueOf(System.now()) + i+Math.random(),
                                                      ELC_Hierarchy__c = 'All',
                                                      ELC_Function__c = 'All',
                                                      Indicator__c = 'All',
                                                      ELC_Additional_Privileges__c = 'None',
                                                      ELC_Correspondence_Language__c = 'All'));
        }
        if(insertRecords){
            insert topics;
        }
        return topics;
    }
    
    // Added By Bruno Molina
    public static List<ELC_MasterConfiguration__c> getLinksWithTopics(Integer total, Boolean insertRecords, Id linkRTId, Id topicId){
        List<ELC_MasterConfiguration__c> links = new List<ELC_MasterConfiguration__c>();
        for(Integer i = 0; i < total; i++){
            links.add(new ELC_MasterConfiguration__c(
                									ELC_Link_name__c = 'Test',
                                                  	recordTypeId = linkRTId,
                                                     ELC_Inactive__c = false,
                                                      ELC_Master_Configuration__c = topicId,
                                                      ELC_Topic_Name__c = 'My Team',
                                                      ELC_PSM_Description__c = 'Test',
                                                      ELC_Start_Date__c = Date.valueOf(system.now()),
                                                      ELC_Links__c = 'Category=New Hire;PreScreen=true;',
                                                      ELC_Job_Function__c = 'All',
                                                      ELC_Brand__c = 'All',
                                                      ELC_Location__c = 'All',
                                                      ELC_Location_Type__c = 'All',
                                                      ELC_MC_External_ID_From_Dev__c ='getLinks' +String.valueOf(System.now()) + i+Math.random(),
                                                      ELC_Hierarchy__c = 'All',
                                                      ELC_Function__c = 'All',
                                                      Indicator__c = 'All',
                                                      ELC_Additional_Privileges__c = 'None',
                                                      ELC_Correspondence_Language__c = 'All'));
        }
        if(insertRecords){
            insert links;
        }
        return links;
    }
    
    // Added By Prateek
    public static List<ELC_Employee_Related_Information__c> getRelatedEmployee(Integer total, Boolean insertRecords, Id contactId){
        List<ELC_Employee_Related_Information__c> relatedEmp = new List<ELC_Employee_Related_Information__c>();
        for(Integer i = 0; i < total; i++){
            relatedEmp.add(new ELC_Employee_Related_Information__c(ELC_Employee__c = contactId,
                                                                   Name='Test',
                                                                   ELC_Work_Location_Building_Name__c='The Bay - Winnipeg',
                                                                   ELC_Global_Grade__c='All',
                                                                   ELC_Brand_Non_Brand__c = 'Brand',
                                                                   ELC_Primary__c = true, // Bruno Molina for PSM Checker test 31/12/2021 >to bypass the trigger, when starting test class, TriggerBypass.setDoNotRunTrigger(); then in the trigger, put all logic inside if (TriggerBypass.doNotBypassTrigger()){}
                                                                   ELC_Work_Location_Country__c='Canada',
                                                                   ELC_Work_Location_City__c = 'Victoria',
                                                                   ELC_Work_Location_State__c = 'Manitoba',
                                                                   ELC_Location__c = 'CA.Winnipeg.The Bay - Winnipeg.Retail Store',
                                                                   //ELC_Primary__c= true, //Aswin @CDG Commented to avoid Apex test class failures 08-09-2020
                                                                   ELC_Work_Location_Type__c='Retail Store',
                                                                   ELC_Job_Function__c='Sales',
                                                                   ELC_Job_Sub_Function__c='Point of Sale Non Management',
                                                                   ELC_High_Level_Organization__c='Brand',
                                                                   ELC_Job_Area__c = 'Beauty Advisor/Artist',
                                                                   ELC_Assignment_Status__c = 'Active Assignment', // Tania : 19/5
                                                                   ELC_Payroll__c = 'All', // OSP-6711 Petricia
                                                                   ELC_Assignment_Category__c = 'All'//OSP-7124
                                                                  ));
        }
        if(insertRecords){
            insert relatedEmp;
        }
        return relatedEmp;
    }
    
    // Added By Prateek
    public static List<Contact> getSetupContact(Integer total,Boolean insertRecords, Id userId){
        List<Contact> contacts = new List<Contact>();
        for(Integer i =0; i <total;i++){
            contacts.add(new Contact(FirstName = 'Stephanie',LastName = 'Wishart',
                                     ELC_Brand_Non_Brand__c = 'Donna Karan',
                                     ELC_Preferred_Name__c = 'Test',
                                     ELC_Position_Title__c = 'MAC Artist',
                                     Email = 'tocooper@estee.ca',
                                     ELC_Correspondence_Language__c = 'American English',
                                     ELC_Manager_Flag__c = true,
                                     ELC_Additional_Privileges__c = 'Has Company Email;Sumtotal User;HR Contact',
                                     ELC_Work_Location_Country__c = 'Canada',
                                     ELC_RelatedUser__c = userId));
        }
        if(insertRecords){
            insert contacts;
        }
        return contacts;
    }
    
    
    public static List<Case> createCasesWithSubpoenaType(Integer total,Boolean insertRecords, String category, String subCategory,String SubpoenaType, Id recordTypeId, Id userId, Id contactId){
        List<Case> cases = new List<Case>();
        for(Integer i =0; i <total;i++){
            cases.add(new Case(ELC_Category__c= category,
                               ELC_SubCategory__c= subCategory,
                               ContactId = contactId,
                               RecordTypeId = recordTypeId,
                               OwnerId = userId,
                               Status = 'New',
                               ELC_Subpoena_Type__c = 'Garnishment',
                               ELC_SubStatus__c = 'Request Submitted',
                               Origin = 'Portal',
                               ELC_AgreedToTerms__c = true,
                               ELC_ProjectName__c = 'Regulatory Test Case from Console'));
        }
        if(insertRecords){
            insert cases;
        }
        return cases;
    }
    
    
    // Updated by Tania : 5/6 : parentId
    public static List<Attachment> createAttachment(Integer total,Boolean insertRecords, String name, String body, Id attParentId){
        List<Attachment> attachments = new List<Attachment>();
        for(Integer i = 0; i < total; i++){
            attachments.add(new Attachment(Name = name, 
                                           Body = Blob.valueOf(body), 
                                           ParentId = attParentId, 
                                           IsPrivate = false));
        }
        if(insertRecords){
            insert attachments;
        }
        return attachments;
    }
    
    
    // Create Articles in Portal    
    public static Knowledge__kav getPortalArticle(String language, String title, String summary,String urlName){
        Id portalRecordTypeId = Schema.SObjectType.Knowledge__kav.getRecordTypeInfosByName().get('Portal_Article').getRecordTypeId();
        Knowledge__kav portalarticle = new Knowledge__kav(Title = title,
                                                          Summary = summary,
                                                          URLName = urlName,
                                                          Language = language, 
                                                          Portal_Article_Content_Type__c='FAQ',RecordTypeId=portalRecordTypeId);
        insert portalarticle;
        System.debug('PORTAL_ARTICLE_INSERTED : '+portalarticle);
        return portalarticle;
    }
    
    //Abhishek@Infosys(28-Nov-2018) : Create Employee Related Record for loggedInUser
    public static void createContactWithRelatedRecordForLoggedInUser(String country){
        Contact c = new Contact();
        c.LastName = 'Test User';
        c.ELC_RelatedUser__c = UserInfo.getUserId();
        c.ELC_Correspondence_Language__c = 'American English';
        insert c;
        ELC_Employee_Related_Information__c eri = new ELC_Employee_Related_Information__c();
        eri.Name = 'ERI-1';
        eri.ELC_Employee__c = c.Id;
        eri.ELC_Work_Location_Country__c = country;
        eri.ELC_Primary__c = TRUE;
        eri.ELC_Assignment_Status__c = 'Active Assignment';
        insert eri;
    }
    
    //Abhishek@Infosys(28-Nov-2018) : Create Picklist Exception Records
    //Anusha Allam@Infosys(25-Dec-2018) - Added recordtypeid to avoid Hard coded Ids
    public static void createPicklistExceptionValues(Integer noOfRecords, String exceptionRegion, Id RecordTypeId){
        ELC_MasterConfiguration__c parentField = new ELC_MasterConfiguration__c();
        parentField.RecordTypeId = RecordTypeId;
        parentField.ELC_FieldNameAPI__c = 'Test_API_Name__c';
        parentField.ELC_MC_External_ID_From_Dev__c = 'Unique_Field_Id';
        insert parentField;
        List<ELC_MasterConfiguration__c> picklistExceptions = new List<ELC_MasterConfiguration__c>();
        for(integer i=0; i<noOfRecords; i++){
            ELC_MasterConfiguration__c picklistException = new ELC_MasterConfiguration__c();
            picklistException.ELC_Parent_Field_Name__c = parentField.Id;
            picklistException.ELC_Description__c = 'Test Description - ' + i;
            picklistException.ELC_MC_External_ID_From_Dev__c = 'PickList_Test_' + i;
            picklistException.ELC_User_Location__c = exceptionRegion;
            picklistExceptions.add(picklistException);
        }
        insert picklistExceptions;
    }
    
    public static void createPortalFieldsWithSection(String category, String subCategory){
        Id fieldRT = getRecordType('ELC_MasterConfiguration__c','ELC_Fields');
        Id sectionRT = getRecordType('ELC_MasterConfiguration__c','ELC_Section');
        
        ELC_MasterConfiguration__c section = new ELC_MasterConfiguration__c( RecordTypeId = sectionRT,
                                                                            ELC_CaseRecordType__c = 'ELC_Legal;ELC_DraftCase;ELC_HR',
                                                                            ELC_Section_Label__c = 'sectionLabel',
                                                                            ELC_OrderOfSection__c = 1,
                                                                            ELC_ColumnsPerSection__c = '2',
                                                                            ELC_Object__c = 'Case',
                                                                            ELC_Type__c = 'Universal',
                                                                            
                                                                            ELC_Universal_Section_Flag__c = true,
                                                                            ELC_Case_Category_Portal__c = category,
                                                                            ELC_Case_Sub_Category_Portal__c = subCategory,
                                                                            ELC_Related_List_Name_Portal__c = 'portalLabel',
                                                                            ELC_CaseCategory__c = category,
                                                                            ELC_CaseSubCategory__c = subCategory,
                                                                            ELC_Service_Information_Object_API__c = 'ELC_Service_Information__c',
                                                                            ELC_User_Location__c = 'All',
                                                                            ELC_MC_External_ID_From_Dev__c =Math.Random()+'g2'+String.valueOf(System.now().getTime())
                                                                           );
        insert section;
        
        ELC_MasterConfiguration__c field = new ELC_MasterConfiguration__c( RecordTypeId = fieldRT,
                                                                          ELC_FieldLabel__c = 'fieldLabel',
                                                                          ELC_FieldNameAPI__c = 'fieldAPI',
                                                                          ELC_Object__c = 'Case',
                                                                          ELC_ParentSectionName__c = section.Id,
                                                                          ELC_Case_Category_Portal__c = category,
                                                                          ELC_Case_Sub_Category_Portal__c = subCategory,
                                                                          ELC_Portal__c = true,
                                                                          ELC_Required_on_New_Page_Portal__c = true,
                                                                          ELC_Required_on_Edit_Page_Portal__c = true,
                                                                          ELC_DefaultValue__c = '',
                                                                          ELC_MC_External_ID_From_Dev__c =Math.random()+'g4'+String.valueOf(System.now().getTime()),
                                                                          ELC_OrderOfField__c = 1,
                                                                          ELC_User_Location__c = 'All'
                                                                         );
        insert field;
    }
    public static String MockResponseTest()
    {
        if(tier==4)
            return '[{"env:Body":{"@xmlns:env":"http://schemas.xmlsoap.org/soap/envelope/","@xmlns:wsu":"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd","@xmlns:wsse":"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd","@xmlns:soap":"http://schemas.xmlsoap.org/soap/envelope/","OutputParameters":{"@xmlns":"http://xmlns.oracle.com/apps/per/soaprovider/plsql/elc_appr_hierarchy_sf/get_approval_details/","@xmlns:xsi":"http://www.w3.org/2001/XMLSchema-instance","P_CASE_NUMBER1":"00047791","P_EMPLOYEE1":"950411","P_NEXT_APPROVER_ID":"HR Pay - DE AFF Confidential","P_EXPIRATION_DATE":"20-MAR-2018 11:08:48","P_NEXT_APPROVER_LEVEL":"1","P_APPROVER_ID_2":"1101003","P_APPROVER_LEVEL_2":"2","P_APPROVER_ID_3":"1535169","P_APPROVER_LEVEL_3":"3","P_APPROVER_ID_4":"HR Connect US","P_APPROVER_LEVEL_4":"4"}},"sl":{"ruuid":"182fc138-4e2d-4427-9cec-0433aed511c8"}}]';
        if(tier==3)
            return '[{"env:Body":{"@xmlns:env":"http://schemas.xmlsoap.org/soap/envelope/","@xmlns:wsu":"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd","@xmlns:wsse":"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd","@xmlns:soap":"http://schemas.xmlsoap.org/soap/envelope/","OutputParameters":{"@xmlns":"http://xmlns.oracle.com/apps/per/soaprovider/plsql/elc_appr_hierarchy_sf/get_approval_details/","@xmlns:xsi":"http://www.w3.org/2001/XMLSchema-instance","P_CASE_NUMBER1":"00047791","P_EMPLOYEE1":"950411","P_NEXT_APPROVER_ID":"477732","P_EXPIRATION_DATE":"20-MAR-2018 11:08:48","P_NEXT_APPROVER_LEVEL":"1","P_APPROVER_ID_2":"1101003","P_APPROVER_LEVEL_2":"2","P_APPROVER_ID_3":"1535169","P_APPROVER_LEVEL_3":"3","P_APPROVER_ID_4":"HR Connect US","P_APPROVER_LEVEL_4":"4"}},"sl":{"ruuid":"182fc138-4e2d-4427-9cec-0433aed511c8"}}]';
        if(tier==1)
            return '[{"env:Body":{"@xmlns:env":"http://schemas.xmlsoap.org/soap/envelope/","@xmlns:wsu":"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd","@xmlns:wsse":"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd","@xmlns:soap":"http://schemas.xmlsoap.org/soap/envelope/","OutputParameters":{"@xmlns":"http://xmlns.oracle.com/apps/per/soaprovider/plsql/elc_appr_hierarchy_sf/get_approval_details/","@xmlns:xsi":"http://www.w3.org/2001/XMLSchema-instance","P_CASE_NUMBER1":"00047791","P_EMPLOYEE1":"950411","P_NEXT_APPROVER_ID":"477732","P_EXPIRATION_DATE":"20-MAR-2018 11:08:48","P_NEXT_APPROVER_LEVEL":"1","P_APPROVER_ID_2":"","P_APPROVER_LEVEL_2":"","P_APPROVER_ID_3":"","P_APPROVER_LEVEL_3":"","P_APPROVER_ID_4":"","P_APPROVER_LEVEL_4":""}},"sl":{"ruuid":"182fc138-4e2d-4427-9cec-0433aed511c8"}}]';
        if(tier==0)
            return '[{"env:Body":{"@xmlns:env":"http://schemas.xmlsoap.org/soap/envelope/","@xmlns:wsu":"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd","@xmlns:wsse":"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd","@xmlns:soap":"http://schemas.xmlsoap.org/soap/envelope/","OutputParameters":{"@xmlns":"http://xmlns.oracle.com/apps/per/soaprovider/plsql/elc_appr_hierarchy_sf/get_approval_details/","@xmlns:xsi":"http://www.w3.org/2001/XMLSchema-instance","P_CASE_NUMBER1":"00047791","P_EMPLOYEE1":"950411","P_NEXT_APPROVER_ID":"HR Connect US","P_EXPIRATION_DATE":"20-MAR-2018 11:08:48","P_NEXT_APPROVER_LEVEL":"1","P_APPROVER_ID_2":"","P_APPROVER_LEVEL_2":"","P_APPROVER_ID_3":"","P_APPROVER_LEVEL_3":"","P_APPROVER_ID_4":"","P_APPROVER_LEVEL_4":""}},"sl":{"ruuid":"182fc138-4e2d-4427-9cec-0433aed511c8"}}]';
        if(tier==-1)
            return '[{"env:Body":{"@xmlns:env":"http://schemas.xmlsoap.org/soap/envelope/","@xmlns:wsu":"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd","@xmlns:wsse":"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd","@xmlns:soap":"http://schemas.xmlsoap.org/soap/envelope/","OutputParameters":{"@xmlns":"http://xmlns.oracle.com/apps/per/soaprovider/plsql/elc_appr_hierarchy_sf/get_approval_details/","@xmlns:xsi":"http://www.w3.org/2001/XMLSchema-instance","P_CASE_NUMBER1":"00047791","P_EMPLOYEE1":"950411","P_NEXT_APPROVER_ID":"{@xsi:nil=true}","P_EXPIRATION_DATE":"20-MAR-2018 11:08:48","P_NEXT_APPROVER_LEVEL":"","P_APPROVER_ID_2":"","P_APPROVER_LEVEL_2":"","P_APPROVER_ID_3":"","P_APPROVER_LEVEL_3":"","P_APPROVER_ID_4":"","P_APPROVER_LEVEL_4":""}},"sl":{"ruuid":"182fc138-4e2d-4427-9cec-0433aed511c8"}}]';
        
        return '';
        
    }
}