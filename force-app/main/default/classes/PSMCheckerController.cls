/*
 * Date             : 31/12/2021
 * Created By       : Bruno Molina
 * Description:     : Custom LWC to check which links the employee has access to.
 * User Stories     : OSP-17826
 */
public class PSMCheckerController {
    @AuraEnabled
    public static List<ELC_Employee_Related_Information__c> getEmployeesByNumber(String empNumber){

                String fnd = '%' + empNumber + '%';
                List<ELC_Employee_Related_Information__c> employeesList = new List<ELC_Employee_Related_Information__c>();
                employeesList=[SELECT 
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
                             ELC_Employee_Related_Information__c 
                             WHERE
                             Name LIKE :fnd AND ELC_Primary__c = true
                             ORDER BY ELC_Assignment_Effective_Start_Date__c DESC, ELC_Assignment_Status__c, LastModifiedDate
                             LIMIT 2]; 

                    System.debug('Employee Filtered List'+ employeesList);
                if(employeesList.size()>0){
                    return employeesList;
                } else {
                    return null;
                }
    }
    @AuraEnabled
    public static String searchPSM( String correspondenceLanguage, Boolean managerFlag, String additionalPrivileges, String jobFunction, String jobSubFunction, 
                            String highLevelOrganization, String jobArea, String workLocationCountry, String workLocationState, String workLocationCity,
                            String workLocationBuildingName, String workLocationType, String globalGrade, String brandNonBrand, String elcFunction,
                            String elcSubFunction, String orgCountryRegion){
        String managerValue = '';
        if (managerFlag == true){
            managerValue = 'Manager';
        }else{
            managerValue = 'Non-Manager';
        }

        List<String> lstadditionalPrivileges = additionalPrivileges.split(';');
        //System.debug('My ELC_PSM_Checker searchPSM lstadditionalPrivileges '+lstadditionalPrivileges);
        String finaladditionalPrivileges = '';
        for(String stradditionalPrivileges : lstadditionalPrivileges){
            finaladditionalPrivileges =  finaladditionalPrivileges + '\'' + stradditionalPrivileges + '\',' ;
        }
        Integer intfinaladditionalPrivilegesLength = finaladditionalPrivileges.length();
        //System.debug('My ELC_PSM_Checker searchPSM intfinaladditionalPrivilegesLength '+intfinaladditionalPrivilegesLength);
        finaladditionalPrivileges = finaladditionalPrivileges.left(intfinaladditionalPrivilegesLength-2);
        //System.debug('My ELC_PSM_Checker searchPSM finaladditionalPrivileges '+finaladditionalPrivileges);
        intfinaladditionalPrivilegesLength = finaladditionalPrivileges.length();
        //System.debug('My ELC_PSM_Checker searchPSM intfinaladditionalPrivilegesLength '+intfinaladditionalPrivilegesLength);
        finaladditionalPrivileges = finaladditionalPrivileges.mid(1,intfinaladditionalPrivilegesLength);
        //System.debug('My ELC_PSM_Checker searchPSM finaladditionalPrivileges '+finaladditionalPrivileges);
        
        //Clustered brand value fix as part of OSP-12040 defect
        brandNonBrand = ELC_OS_Portal_Util.breakStringByDelim(brandNonBrand);
        brandNonBrand = brandNonBrand.substring(1, brandNonBrand.length()-1);
    
        String soqlQuery = 'Select  Name,  ELC_Master_Configuration__r.ELC_Topic_Name__c, ELC_Master_Configuration2__r.ELC_Sub_Topic_Name__c, ELC_Link_name__c, ELC_MC_External_ID_From_Dev__c, '+ 
            'ELC_Links__c, ELC_Job_Function__c, ELC_Location__c, ELC_Start_Date__c, Elc_End_Date__c, ELC_Links_Order__c FROM   ELC_MasterConfiguration__c ' +
            'WHERE ELC_Job_Function__c includes (\'' + jobFunction + '\',\'' + jobSubFunction + '\',\'' + highLevelOrganization + '\',\'' + jobArea  + '\',\'All\') AND '+
            'ELC_Function__c includes (\'' + elcFunction + '\',\'' + elcSubFunction + '\',\'' + orgCountryRegion + '\',\'All\') AND '+
            'ELC_Correspondence_Language__c in (\'' + correspondenceLanguage + '\',\'All\') AND '+
            'ELC_Brand__c includes (\'' + brandNonBrand + '\',\'All\') AND '+
            'ELC_Additional_Privileges__c includes (\'' + finaladditionalPrivileges + '\',\'None\') AND '+
            'ELC_Location__c includes (\'' +workLocationBuildingName + '\',\'' + workLocationCity + '\',\'' + workLocationState + '\',\'' + workLocationCountry + '\',\'All\') AND '+
            'ELC_Location_Type__c includes (\'' + workLocationType + '\',\'All\') AND '+
            'ELC_Hierarchy__c includes (\'' + managerValue + '\',\'' + globalGrade + '\',\'All\') AND '+
            '((ELC_Inactive__c = false AND ELC_Master_Configuration2__r.ELC_Inactive__c = false AND ' +
            'ELC_Master_Configuration2__r.ELC_Master_Configuration3__r.ELC_Inactive__c = false AND ' +
            'ELC_Master_Configuration2__r.ELC_Master_Configuration3__r.ELC_Component__c includes (\'Header Footer Page\'' +
            ',\'App Menu\',\'Need more help\',\'Trending on OneSource\',\'Action Items\',\'Footer\',\'Request Catalog\')' +
            ') OR (ELC_Inactive__c = false AND ELC_Master_Configuration2__c = null AND ELC_Master_Configuration__r.ELC_Inactive__c = false AND ' +
            'ELC_Master_Configuration__r.ELC_Component__c includes (\'Header Footer Page\',\'App Menu\',\'Need more help\',\'Trending on OneSource\',\'Action Items\',\'Footer\',\'Request Catalog\')' +
            ')) AND  ((ELC_Start_Date__c <= TODAY  AND ELC_End_date__c >= TODAY ) OR (ELC_Start_Date__c != null AND ' +
            'ELC_Start_Date__c <= TODAY AND ELC_End_date__c = null )) ORDER BY ELC_Links_Order__c, ELC_Master_Configuration__r.ELC_Topic_Name__c';
        system.debug('My Test searchPSM soqlQuery '+soqlQuery );

        List<ELC_MasterConfiguration__c> withAccessPSM = Database.query(soqlQuery);  
       // System.debug('first PSM query result ==> '+withAccessPSM);
        
        Map<Id, ELC_MasterConfiguration__c> allformsmap = new Map<Id, ELC_MasterConfiguration__c>([Select id,Name,ELC_Master_Configuration__r.ELC_Topic_Name__c, ELC_Master_Configuration2__r.ELC_Sub_Topic_Name__c, ELC_Link_name__c FROM   ELC_MasterConfiguration__c where ELC_Master_Configuration__r.ELC_Topic_Name__c!=null ORDER BY ELC_Master_Configuration__r.ELC_Topic_Name__c LIMIT 1000]);
     //   system.debug('allformsmap size before'+allformsmap.size());
        for(ELC_MasterConfiguration__c withAccessPSMrecord : withAccessPSM){
            
            if(allformsmap.containsKey(withAccessPSMrecord.id)){
                allformsmap.remove(withAccessPSMrecord.id);
            }
        }
        
        List<ELC_MasterConfiguration__c> noAccessPSM = allformsmap.values();
     //   System.debug('No Access PSM query result ==> '+noAccessPSM);
        
        List<wrapExternalLinks> externalLinkList = getExternalLinks(workLocationCountry, brandNonBrand);

        PSMWrapper psmWrapper = new psmWrapper(withAccessPSM, noAccessPSM, externalLinkList);
      //  System.debug('psmWrapper ==> '+psmWrapper);


        return JSON.serialize(psmWrapper);
    }
    public static List<wrapExternalLinks> getExternalLinks(String country, String brand){
        String recordTypeName = 'BrandTileLogos';
        
        List<String> myELChoicesCountryList = System.Label.MyELChoicesCountries.split('/');
            
        String countryLinkQuery = 'select Id, Label, ELC_Countries__c, ELC_MyELCIntranetLink__c, MyELChoicesLink__c from CountrytoLink_PSM__mdt';
        List<CountrytoLink_PSM__mdt> countryLink = Database.query(countryLinkQuery);
        
        List<ELC_MasterConfiguration__c> brandLink = new List<ELC_MasterConfiguration__c>();
        //Below conditional block is written to match the logic in ELC_OS_Portal_Brandspace.vfc.
        if(brand!=null && brand!=''){
            if(brand.contains('/')){
                brand = 'multiple';
            }
            String brandLinkQuery = 'select Id, ELC_Brand__c, ELC_URL__c, ELC_Link_name__c, ELC_Link_Type__c FROM ELC_MasterConfiguration__c WHERE recordType.DeveloperName = :recordTypeName AND ELC_Brand__c = :brand AND ELC_Inactive__c=false';
        	brandLink = Database.query(brandLinkQuery);
        }
        
        
        List<wrapExternalLinks> externalLinks = new List<wrapExternalLinks>();
        for(CountrytoLink_PSM__mdt data : countryLink){
            if(data.ELC_Countries__c.contains(country)){
                externalLinks.add(new wrapExternalLinks(Label.Links_MC_03890_Dev, data.ELC_MyELCIntranetLink__c));
                if(myELChoicesCountryList.contains(country)){
                    externalLinks.add(new wrapExternalLinks(Label.Links_MC_05010_1_Dev, data.MyELChoicesLink__c));
                }
                //Forced to exit from loop as CountrytoLink_PSM__mdt contain multiple records with same countries.
                break;
            }
        }
        
        for(ELC_MasterConfiguration__c data : brandLink){
            externalLinks.add(new wrapExternalLinks(data.ELC_Link_name__c, data.ELC_URL__c));
        }
        return externalLinks;
    }
    
    public class wrapExternalLinks{
        public String linkName {get;set;}
        public String linkURL {get;set;}
        
        public wrapExternalLinks(String name, String url){
            linkName = name;
            linkURL = url;
    	}
    }
    public class PSMWrapper {
        public List<ELC_MasterConfiguration__c> withAccessPSM {get;set;}
        public List<ELC_MasterConfiguration__c> noAccessPSM {get;set;}
        public List<wrapExternalLinks> externalLinkList {get;set;}

        public PSMWrapper(List<ELC_MasterConfiguration__c> withAccessPSM, List<ELC_MasterConfiguration__c> noAccessPSM, List<wrapExternalLinks> externalLinkList) {
            this.withAccessPSM = withAccessPSM;
            this.noAccessPSM = noAccessPSM;
            this.externalLinkList = externalLinkList;
        }
    }
    @AuraEnabled
    public static List<ELC_MasterConfiguration__c> extractPSM(){
        System.debug('=====extractPSM invoked ====');
        List<ELC_MasterConfiguration__c> pSMExtract = new List<ELC_MasterConfiguration__c>();
        pSMExtract = [Select  Id, Name, ELC_Master_Configuration__r.ELC_Topic_Name__c, ELC_Master_Configuration__r.Name, ELC_Master_Configuration2__r.ELC_Sub_Topic_Name__c, ELC_Master_Configuration2__r.Name, 
        ELC_Link_name__c, ELC_Location__c, ELC_Location_Type__c, ELC_Job_Function__c, ELC_Function__c, ELC_Hierarchy__c, ELC_Payroll__c, ELC_Correspondence_Language__c, Indicator__c, ELC_Brand__c,
        ELC_Additional_Privileges__c, ELC_Links__c, ELC_Links_Order__c, ELC_Link_keywords__c, ELC_Icon_Type__c, RecordType.Name, ELC_MC_External_ID_From_Dev__c
        FROM ELC_MasterConfiguration__c WHERE ELC_Inactive__c = false AND RecordType.Name = 'Links' ORDER BY ELC_Master_Configuration__r.ELC_Topic_Name__c ASC];
        return pSMExtract;
    }
}