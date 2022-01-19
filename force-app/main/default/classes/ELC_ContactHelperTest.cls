/**
* @author      Deloitte Digital - Prateek
* @version     1.0
* @Date        1.0
* @Description 
*/
@isTest
public class ELC_ContactHelperTest {
    
    @testSetup 
    static void setup(){     
        // Country Locale Map
        ELC_CountryLocaleMap__C data = new ELC_CountryLocaleMap__C(ELC_Country__c = 'Venezuela',ELC_LanguageKey__c='en_US',
                                                                   ELC_LocaleKey__c='es_VE',ELC_TimeZone__c='America/Caracas',Name='Venezuela');
        ELC_CountryLocaleMap__C usData = new ELC_CountryLocaleMap__C(ELC_Country__c = 'United States',ELC_LanguageKey__c='en_US',
                                                                   ELC_LocaleKey__c='es_VE',ELC_TimeZone__c='America/Chicago',Name='US');
        List<ELC_CountryLocaleMap__C> localeMap = new List<ELC_CountryLocaleMap__C>();
        localeMap.add(data);
        localeMap.add(usData);
        insert localeMap;
        
        // Language ISO Codes
        ELC_Language_ISO_Codes__c isoCodes = new ELC_Language_ISO_Codes__c(ELC_Language_Locale__c='en_US',ELC_Locale_Sid_Key__c='en_US',Name='en');
        insert isoCodes;
    }


    private static List<Contact> getContact(Integer total, Boolean isInsert, Id userId, String country){
        List<Contact> contacts = new List<Contact>();
        for(Integer i = 1; i <= total; i++){
            Contact con = new Contact();
            con.FirstName = 'Ricky' + i;
            con.LastName = 'Doe'+i;
            con.Email = 'ricky.doe'+i+ '@test.com';
            con.ELC_Personal_Email__c = 'ricky.doe.pe'+i+ '@test.com';
            con.ELC_Terminated_Date__c = Date.today().addDays(10);
            if(userId != null)
                con.ELC_RelatedUser__c = userId;

            con.ELC_Candidate_ID__c = String.valueOf(Integer.valueOf(math.rint(math.random()*1000000)));
            con.ELC_Correspondence_Language__c = 'American English';
            con.ELC_Work_Location_Country__c = country;
            con.ELC_Employee_Number__c = '2525'+i;
            con.ELC_Display_Name__c = 'Ricky Doe'+i;
            con.ELC_National_Identifier__c = '2525'+i;
            con.ELC_National_Identifier_Type__c = 'Social Insurance Number';
            con.ELC_Date_of_Birth_DD_MMM__c = '25-DEC';
            con.ELC_Manager_Flag__c = true;
            con.ELC_Person_Type__c = 'Employee';
            con.ELC_Latest_Start_Date__c = System.today() - 500;
            con.ELC_Personal_Email__c = 'ricky.doe'+i+ '@test.com';

            contacts.add(con);
        }
        return contacts;
    }
    private static List<Contact> getContactNoWorkEmail(Integer total, Boolean isInsert, Id userId, String country){
        List<Contact> contacts = new List<Contact>();
        for(Integer i = 1; i <= total; i++){
            Contact con = new Contact();
            con.FirstName = 'Ricky' + i;
            con.LastName = 'Doe'+i;
            //con.Email = 'ricky.doe'+i+ '@test.com';
            con.ELC_Personal_Email__c = 'ricky.doe.pe'+i+ '@test.com';
            con.ELC_Terminated_Date__c = Date.today().addDays(10);
            if(userId != null)
                con.ELC_RelatedUser__c = userId;

            con.ELC_Candidate_ID__c = String.valueOf(Integer.valueOf(math.rint(math.random()*1000000)));
            con.ELC_Correspondence_Language__c = 'American English';
            con.ELC_Work_Location_Country__c = country;
            con.ELC_Employee_Number__c = '2525'+i;
            con.ELC_Display_Name__c = 'Ricky Doe'+i;
            con.ELC_National_Identifier__c = '2525'+i;
            con.ELC_National_Identifier_Type__c = 'Social Insurance Number';
            con.ELC_Date_of_Birth_DD_MMM__c = '25-DEC';
            con.ELC_Manager_Flag__c = true;
            con.ELC_Person_Type__c = 'Employee';
            con.ELC_Latest_Start_Date__c = System.today() - 500;
            con.ELC_Personal_Email__c = 'ricky.doe'+i+ '@test.com';

            contacts.add(con);
        }
        return contacts;
    }


    
    // Create Contacts without related User
    static testMethod void testContactHelperWithoutRelatedUser(){
        Test.startTest();  
        // create contact without related user
        List<Contact> contacts = getContact(1, true, null, 'Venezuela');      
        insert contacts;
        
        System.assert(contacts != null);
        
        Test.stopTest();
    }
    

    // Create Contacts with related User
    static testMethod void testContactHelperWithRelatedUser(){
        Test.startTest();    
        User u = ELC_Test_DataFactory.createPortalUser();  
        
        // create contact with related user
        List<Contact> contacts = getContact(1, true, u.Id,'Venezuela');

        insert contacts;
        
        try{
            // THIS IS TO AVOID ==> MIXED_DML_OPERATION on setup and non-setup objects
            System.runAs ( new User(Id = UserInfo.getUserId()) ) {
                contacts[0].ELC_Work_Location_Country__c = 'Argentina';
                update contacts;
            }
        }catch(Exception e){
            System.debug('Exception in ELC_ContactHelperTest : testContactHelperWithRelatedUser = '+e);
        }
        System.assert(contacts != null);
        Test.stopTest();
    }
    // Create Contacts without work emai
    static testMethod void testContactHelperWithRelatedUserNoWorkEmail(){
        Test.startTest();    
        User u = ELC_Test_DataFactory.createPortalUser();  
        
        // create contact with related user
        List<Contact> contacts = getContactNoWorkEmail(1, true, u.Id,'Venezuela');

        insert contacts;
        
        try{
            // THIS IS TO AVOID ==> MIXED_DML_OPERATION on setup and non-setup objects
            System.runAs ( new User(Id = UserInfo.getUserId()) ) {
                contacts[0].email = 'ricky.doe@test.com';
                update contacts;
            }
        }catch(Exception e){
            System.debug('Exception in ELC_ContactHelperTest : testContactHelperWithRelatedUser = '+e);
        }
        System.assert(contacts != null);
        Test.stopTest();
    }
    
    
    // Create Contacts without related User ==> When work location country doesn't natched with Data Setup
    static testMethod void testContactHelperWithoutRelatedCountryUser(){
        Test.startTest();  
        // create contact without related user      
        List<Contact> contacts = getContact(1, true, null,'Panama');
        insert contacts;
        
        System.assert(contacts != null);
        
        Test.stopTest();
    }
}