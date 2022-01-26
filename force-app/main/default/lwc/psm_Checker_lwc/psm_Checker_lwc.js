/*
 * Date             : 31/12/2021
 * Created By       : Bruno Molina
 * Description:     : Custom LWC to check which links the employee has access to.
 * User Stories     : OSP-17826
 */
import { api, LightningElement, track, wire } from 'lwc';
import searchPSM from '@salesforce/apex/PSMCheckerController.searchPSM';
import getEmployeesByNumber from '@salesforce/apex/PSMCheckerController.getEmployeesByNumber';
import extractPSM from '@salesforce/apex/PSMCheckerController.extractPSM';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { loadScript } from "lightning/platformResourceLoader";
import workbook from "@salesforce/resourceUrl/writeExcel";
import USER_PERMISSION from '@salesforce/customPermission/PSMExtractPermission';

const employeeColumns = [
    {   type: 'button',
        typeAttributes: {
            label: 'Check PSM'
        }, initialWidth: 110
    },
    /* { label: 'First Name', fieldName: 'FirstName', wrapText: true, hideDefaultActions: true }, */
    { label: 'First Name', fieldName: 'url', wrapText: true, hideDefaultActions: true, sortable: "true", type: "url",
        typeAttributes: {label: {fieldName: "FirstName"}}, initialWidth: 80
    },
    { label: 'Last Name', fieldName: 'LastName', wrapText: true, hideDefaultActions: true, initialWidth: 100 },
    { label: 'Correspondence Language', fieldName: 'ELC_Correspondence_Language__c', wrapText: true, hideDefaultActions: true, initialWidth: 80},
    { label: 'Manager Flag', fieldName: 'ELC_Manager_Flag__c', type: 'checkbox', wrapText: true, hideDefaultActions: true, initialWidth: 80 },
    { label: 'Additional Privileges', fieldName: 'ELC_Additional_Privileges__c', hideDefaultActions: true, wrapText: true, hideDefaultActions: true, initialWidth: 110},
    { label: 'Job Function', fieldName: 'ELC_Job_Function__c', wrapText: true, hideDefaultActions: true, initialWidth: 80},
    { label: 'Job Sub Function', fieldName: 'ELC_Job_Sub_Function__c', wrapText: true, hideDefaultActions: true, initialWidth: 110},
    { label: 'High Level Organization', fieldName: 'ELC_High_Level_Organization__c', wrapText: true, hideDefaultActions: true, initialWidth: 80},
    { label: 'Job Area', fieldName: 'ELC_Job_Area__c', wrapText: true, hideDefaultActions: true, initialWidth: 80},
    { label: 'Work Location Country', fieldName: 'ELC_Work_Location_Country__c', wrapText: true, hideDefaultActions: true, initialWidth: 80},
    { label: 'Work Location State', fieldName: 'ELC_Work_Location_State__c', wrapText: true, hideDefaultActions: true, initialWidth: 80},
    { label: 'Work Location City', fieldName: 'ELC_Work_Location_City__c', wrapText: true, hideDefaultActions: true, initialWidth: 80},
    { label: 'Work Location Building Name', fieldName: 'ELC_Work_Location_Building_Name__c', wrapText: true, hideDefaultActions: true, initialWidth: 80},
    { label: 'Work Location Type', fieldName: 'ELC_Work_Location_Type__c', wrapText: true, hideDefaultActions: true, initialWidth: 80},
    { label: 'Global Grade', fieldName: 'ELC_Global_Grade__c', wrapText: true, hideDefaultActions: true, initialWidth: 80},
    { label: 'Brand / Non Brand', fieldName: 'ELC_Brand_Non_Brand__c', wrapText: true, hideDefaultActions: true, initialWidth: 80},
    { label: 'Function', fieldName: 'ELC_Function__c', wrapText: true, hideDefaultActions: true, initialWidth: 80},
    { label: 'Sub Function', fieldName: 'ELC_SubFunction__c', wrapText: true, hideDefaultActions: true, initialWidth: 80},
    { label: 'Organization Country / Region', fieldName: 'ELC_Organization_Country_Region__c', wrapText: true, hideDefaultActions: true},
];
const accessPSMColumns = [
    { label: 'Name', fieldName: 'url', wrapText: true, hideDefaultActions: true, sortable: "true", type: "url",
        typeAttributes: {label: {fieldName: "Name"}}, initialWidth: 70
    },
    { label: 'Topic Name', fieldName: 'ELC_Topic_Name__c', wrapText: true, hideDefaultActions: true, sortable: "true", initialWidth: 300 },
    { label: 'Sub Topic Name', fieldName: 'ELC_Sub_Topic_Name__c', wrapText: true, hideDefaultActions: true, sortable: "true", initialWidth: 300 },
    { label: 'Link Name / Form Name', fieldName: 'ELC_Link_name__c', wrapText: true, hideDefaultActions: true, sortable: "true", initialWidth: 2000 },

];
const noAccessPSMColumns = [
    { label: 'Name', fieldName: 'url', wrapText: true, hideDefaultActions: true, sortable: "true", type: "url",
        typeAttributes: {label: {fieldName: "Name"}}, initialWidth: 70
    },
    { label: 'Topic Name', fieldName: 'ELC_Topic_Name__c', wrapText: true, hideDefaultActions: true, sortable: "true", initialWidth: 300 },
    { label: 'Sub Topic Name', fieldName: 'ELC_Sub_Topic_Name__c', wrapText: true, hideDefaultActions: true, sortable: "true", initialWidth: 300 },
    { label: 'Link Name/Form Name', fieldName: 'ELC_Link_name__c', wrapText: true, hideDefaultActions: true, sortable: "true", initialWidth: 2000 },

];
const trendingOnOneSourceColumns = [
    { label: 'Name', fieldName: 'url', wrapText: true, hideDefaultActions: true, sortable: "true", type: "url",
        typeAttributes: {label: {fieldName: "Name"}}, initialWidth: 70
    },
    { label: 'Link Name / Form Name', fieldName: 'ELC_Link_name__c', wrapText: true, hideDefaultActions: true, sortable: "true", initialWidth: 300 },
    { label: 'Links Order', fieldName: 'ELC_Links_Order__c', wrapText: true, hideDefaultActions: true, sortable: "true", initialWidth: 80 },
    { label: 'ELC Job Function', fieldName: 'ELC_Job_Function__c', wrapText: true, hideDefaultActions: true, sortable: "true", initialWidth: 110 },
    { label: 'ELC Location', fieldName: 'ELC_Location__c', wrapText: true, hideDefaultActions: true, sortable: "true", initialWidth: 90 },
    { label: 'Link Start Date', fieldName: 'ELC_Start_Date__c', wrapText: true, hideDefaultActions: true, sortable: "true", initialWidth: 100 },
    { label: 'Link End Date', fieldName: 'Elc_End_Date__c', wrapText: true, hideDefaultActions: true, sortable: "true", initialWidth: 90 },
    { label: 'Link (URL)', fieldName: 'ELC_Links__c', wrapText: false, hideDefaultActions: true, sortable: "true", type: "url"},

];
const externalLinksColumns = [
    { label: 'Link Name', fieldName: 'linkName', wrapText: true, hideDefaultActions: true, sortable: "true" },
    { label: 'Link URL', fieldName: 'linkURL', wrapText: true, hideDefaultActions: true, sortable: "true" },
];

export default class Psm_Checker_lwc extends LightningElement {
    @track prfName;

    @track employeeColumns = employeeColumns;
    @track accessPSMColumns = accessPSMColumns;
    @track noAccessPSMColumns = noAccessPSMColumns;
    @track trendingOnOneSourceColumns = trendingOnOneSourceColumns;
    @track externalLinksColumns = externalLinksColumns;
    
    @track accessPSMList;
    allAccessPSMList;
    @track noAccessPSMList;
    allNoAccessPSMList;
    @track trendingOnOneSourceList;
    allTrendingOnOneSourceList;
    @track employeesList;
    @track externalLinkList;

    @track buttonDisabledTrue = true;

    @track psmExtract;

    @track sortBy='ELC_Link_name__c';
    @track sortDirection='asc';
    @track listName='accessPSMList';

    @api searchValue = '';

    @api showSpinner = false;

    @track employeesByNumber;

    @track extractPSMButtonDisabledTrue = true;

    connectedCallback(){
        this.validatePSMButton();
    }

    validatePSMButton(){
        if(USER_PERMISSION == true){
            this.extractPSMButtonDisabledTrue = false;
        }
    }

    searchKeyword(event) {
        //console.log('event.target.value: '+ event.target.value);
        this.searchValue = event.target.value;
            if(this.searchValue !== ""){
            this.buttonDisabledTrue = false;
        } if(this.searchValue == ""){
            this.buttonDisabledTrue = true;
        }
        //console.log('searchKeyword value: '+ this.searchValue);
    }

    handleSearchKeyword() {
        this.showSpinner = true;
        this.employeesByNumber = null;
        this.accessPSMList = null;
        getEmployeesByNumber({empNumber: this.searchValue})
        .then(result => {
            //console.log('result ==> '+JSON.stringify(result))
            if(result != null){
                let prepareList = [];
                result.forEach(function(item){
                    let prepareItem = {};
                    prepareItem.Id = item.Id;
                    prepareItem.FirstName = item.ELC_Employee__r.FirstName;
                    prepareItem.LastName = item.ELC_Employee__r.LastName;
                    prepareItem.ELC_Correspondence_Language__c = item.ELC_Employee__r.ELC_Correspondence_Language__c;
                    prepareItem.ELC_Manager_Flag__c = item.ELC_Employee__r.ELC_Manager_Flag__c;
                    prepareItem.ELC_Additional_Privileges__c = item.ELC_Employee__r.ELC_Additional_Privileges__c;
                    prepareItem.ELC_Job_Function__c = item.ELC_Job_Function__c;
                    prepareItem.ELC_Job_Sub_Function__c = item.ELC_Job_Sub_Function__c;
                    prepareItem.ELC_High_Level_Organization__c = item.ELC_High_Level_Organization__c;
                    prepareItem.ELC_Job_Area__c = item.ELC_Job_Area__c;
                    prepareItem.ELC_Work_Location_Country__c = item.ELC_Work_Location_Country__c;
                    prepareItem.ELC_Work_Location_State__c = item.ELC_Work_Location_State__c;
                    prepareItem.ELC_Work_Location_City__c = item.ELC_Work_Location_City__c;
                    prepareItem.ELC_Work_Location_Building_Name__c = item.ELC_Work_Location_Building_Name__c;
                    prepareItem.ELC_Work_Location_Type__c = item.ELC_Work_Location_Type__c;
                    prepareItem.ELC_Global_Grade__c = item.ELC_Global_Grade__c;
                    prepareItem.ELC_Brand_Non_Brand__c = item.ELC_Brand_Non_Brand__c;
                    prepareItem.ELC_Function__c = item.ELC_Function__c;
                    prepareItem.ELC_SubFunction__c = item.ELC_SubFunction__c;
                    prepareItem.ELC_Organization_Country_Region__c = item.ELC_Organization_Country_Region__c;
                    prepareItem.url = '/' + item.ELC_Employee__c;

                    prepareList.push(prepareItem);
                });
                this.showSpinner = false;
                this.employeesByNumber = prepareList;
                //console.log('employeesByNumber UPDATED ==> '+JSON.stringify(this.employeesByNumber));
                const event = new ShowToastEvent({
                    title: 'Employee record found',
                    variant: 'success'
                });
                this.dispatchEvent(event);
            } else {
                this.showSpinner = false;
                const event = new ShowToastEvent({
                    title : 'No Result',
                    variant : 'warning'
                });
                this.dispatchEvent(event);
            }
            //console.log("employee by number found: "+JSON.stringify(result));
        })
        .catch(error => {
            this.employeesByNumber = null;
            this.showSpinner = false; 
            const event = new ShowToastEvent({
                title : 'Error',
                message : JSON.stringify(error),
                variant : 'error'
            });
            this.dispatchEvent(event);
        })
        
    }

    retrievePSM(event){
        this.showSpinner = true;
        //console.log('clicking on result row ==> '+JSON.stringify(event.detail.row));
        let selectedRow = event.detail.row;
        let correspondenceLanguage = selectedRow.ELC_Correspondence_Language__c;
        let managerFlag = selectedRow.ELC_Manager_Flag__c;
        let additionalPrivileges = selectedRow.ELC_Additional_Privileges__c;
        let jobFunction = selectedRow.ELC_Job_Function__c;
        let jobSubFunction = selectedRow.ELC_Job_Sub_Function__c;
        let highLevelOrganization = selectedRow.ELC_High_Level_Organization__c;
        let jobArea = selectedRow.ELC_Job_Area__c;
        let workLocationCountry = selectedRow.ELC_Work_Location_Country__c;
        let workLocationState = selectedRow.ELC_Work_Location_State__c;
        let workLocationCity = selectedRow.ELC_Work_Location_City__c;
        let workLocationBuildingName = selectedRow.ELC_Work_Location_Building_Name__c;
        let workLocationType = selectedRow.ELC_Work_Location_Type__c;
        let globalGrade = selectedRow.ELC_Global_Grade__c; 
        let brandNonBrand = selectedRow.ELC_Brand_Non_Brand__c;
        let elcFunction = selectedRow.ELC_Function__c;
        let elcSubFunction = selectedRow.ELC_SubFunction__c;
        let orgCountryRegion = selectedRow.ELC_Organization_Country_Region__c;

        searchPSM({
            correspondenceLanguage : correspondenceLanguage,
            managerFlag : managerFlag,
            additionalPrivileges : additionalPrivileges,
            jobFunction : jobFunction,
            jobSubFunction : jobSubFunction,
            highLevelOrganization : highLevelOrganization,
            jobArea : jobArea,
            workLocationCountry : workLocationCountry,
            workLocationState : workLocationState,
            workLocationCity : workLocationCity,
            workLocationBuildingName : workLocationBuildingName,
            workLocationType : workLocationType,
            globalGrade : globalGrade,
            brandNonBrand : brandNonBrand,
            elcFunction : elcFunction,
            elcSubFunction : elcSubFunction,
            orgCountryRegion : orgCountryRegion
        })
        .then(result =>{
            if(result != null){
                var psmList = JSON.parse(result);
                //console.log('result = '+JSON.stringify(psmList));
                let prepareAccessList = [];
                let prepareTrendingOnOneSourceList = [];
                for(let i = 0 ; i < psmList.withAccessPSM.length; i++){
                   let prepareAccessItem = {};
                   let prepareTrendingOnOneSourceItem = {}
                   prepareAccessItem.Id = psmList.withAccessPSM[i].Id;
                   prepareAccessItem.Name = psmList.withAccessPSM[i].Name;
                   prepareAccessItem.url = '/'+psmList.withAccessPSM[i].Id;
                    if(psmList.withAccessPSM[i].hasOwnProperty('ELC_Master_Configuration__r')){
                        if(psmList.withAccessPSM[i].ELC_Master_Configuration__r.hasOwnProperty('ELC_Topic_Name__c')){
                        prepareAccessItem.ELC_Topic_Name__c = psmList.withAccessPSM[i].ELC_Master_Configuration__r.ELC_Topic_Name__c;
                            if(psmList.withAccessPSM[i].ELC_Master_Configuration__r.ELC_Topic_Name__c == 'Trending on OneSource'){
                                prepareTrendingOnOneSourceItem.Id = psmList.withAccessPSM[i].Id;
                                prepareTrendingOnOneSourceItem.Name = psmList.withAccessPSM[i].Name;
                                prepareTrendingOnOneSourceItem.ELC_Links_Order__c = psmList.withAccessPSM[i].ELC_Links_Order__c;
                                prepareTrendingOnOneSourceItem.url = '/'+psmList.withAccessPSM[i].Id;
                                prepareTrendingOnOneSourceItem.ELC_Topic_Name__c = psmList.withAccessPSM[i].ELC_Master_Configuration__r.ELC_Topic_Name__c;
                                prepareTrendingOnOneSourceItem.ELC_Link_name__c = psmList.withAccessPSM[i].ELC_Link_name__c;
                                prepareTrendingOnOneSourceItem.ELC_Links__c = psmList.withAccessPSM[i].ELC_Links__c;
                                prepareTrendingOnOneSourceItem.ELC_Job_Function__c = psmList.withAccessPSM[i].ELC_Job_Function__c;
                                prepareTrendingOnOneSourceItem.ELC_Location__c = psmList.withAccessPSM[i].ELC_Location__c;
                                prepareTrendingOnOneSourceItem.ELC_Start_Date__c = psmList.withAccessPSM[i].ELC_Start_Date__c;
                                prepareTrendingOnOneSourceItem.Elc_End_Date__c = psmList.withAccessPSM[i].Elc_End_Date__c;
                                prepareTrendingOnOneSourceItem.listName = 'trendingOnOneSourceList';

                                if(psmList.withAccessPSM[i].hasOwnProperty('ELC_Master_Configuration2__r')){
                                    if(psmList.withAccessPSM[i].ELC_Master_Configuration2__r.hasOwnProperty('ELC_Sub_Topic_Name__c')){
                                    prepareTrendingOnOneSourceItem.ELC_Sub_Topic_Name__c = psmList.withAccessPSM[i].ELC_Master_Configuration2__r.ELC_Sub_Topic_Name__c;
                                    }
                                }
                                prepareTrendingOnOneSourceList.push(prepareTrendingOnOneSourceItem);
                            }
                        }  

                    }
                    if(psmList.withAccessPSM[i].hasOwnProperty('ELC_Master_Configuration2__r')){
                        if(psmList.withAccessPSM[i].ELC_Master_Configuration2__r.hasOwnProperty('ELC_Sub_Topic_Name__c')){
                            prepareAccessItem.ELC_Sub_Topic_Name__c = psmList.withAccessPSM[i].ELC_Master_Configuration2__r.ELC_Sub_Topic_Name__c;
                        }

                    } 
                   prepareAccessItem.ELC_Link_name__c = psmList.withAccessPSM[i].ELC_Link_name__c;
                   prepareAccessItem.listName = 'accessPSMList';
                   
                   prepareAccessList.push(prepareAccessItem);
                   
                }
                let prepareNoAccessList = [];
                for(let i = 0 ; i < psmList.noAccessPSM.length; i++){
                    let prepareNoAccessItem = {};
                    prepareNoAccessItem.Id = psmList.noAccessPSM[i].Id;
                    prepareNoAccessItem.Name = psmList.noAccessPSM[i].Name;
                    prepareNoAccessItem.url = '/'+psmList.noAccessPSM[i].Id;
                    if(psmList.noAccessPSM[i].hasOwnProperty('ELC_Master_Configuration__r')){
                        if(psmList.noAccessPSM[i].ELC_Master_Configuration__r.hasOwnProperty('ELC_Topic_Name__c')){
                            prepareNoAccessItem.ELC_Topic_Name__c = psmList.noAccessPSM[i].ELC_Master_Configuration__r.ELC_Topic_Name__c;
                        }
                        
                    } 
                    if(psmList.noAccessPSM[i].hasOwnProperty('ELC_Master_Configuration2__r')){
                        if(psmList.noAccessPSM[i].ELC_Master_Configuration2__r.hasOwnProperty('ELC_Sub_Topic_Name__c')){
                            prepareNoAccessItem.ELC_Sub_Topic_Name__c = psmList.noAccessPSM[i].ELC_Master_Configuration2__r.ELC_Sub_Topic_Name__c;
                        }
                        
                    } 
                    prepareNoAccessItem.ELC_Link_name__c = psmList.noAccessPSM[i].ELC_Link_name__c;
                    prepareNoAccessItem.listName = 'noAccessPSMList';
                    
                    prepareNoAccessList.push(prepareNoAccessItem);
                }
                let PrepareExternalLinkList = [];
                for(let i = 0 ; i < psmList.externalLinkList.length; i++){
                    let prepareExternalLinkItem = {};
                    prepareExternalLinkItem.linkName = psmList.externalLinkList[i].linkName;
                    prepareExternalLinkItem.linkURL = psmList.externalLinkList[i].linkURL;
                    prepareExternalLinkItem.listName = 'externalLinkList';

                   PrepareExternalLinkList.push(prepareExternalLinkItem);
                }
                this.showSpinner = false;
                this.accessPSMList = prepareAccessList;
                this.allAccessPSMList = prepareAccessList;
                this.trendingOnOneSourceList = prepareTrendingOnOneSourceList;
                this.allTrendingOnOneSourceList = prepareTrendingOnOneSourceList;
                this.noAccessPSMList = prepareNoAccessList;
                this.allNoAccessPSMList = prepareNoAccessList;
                this.externalLinkList = PrepareExternalLinkList;
                this.sortData(this.sortBy, this.sortDirection, this.accessPSMList[0].listName);
                this.sortData(this.sortBy, this.sortDirection, this.noAccessPSMList[0].listName);
                this.sortData('ELC_Links_Order__c', this.sortDirection, this.trendingOnOneSourceList[0].listName);
                const event = new ShowToastEvent({
                    title: 'PSM Retrieved',
                    variant: 'success'
                });
                this.dispatchEvent(event);
            }
        })
        .catch(error =>{});

     //   console.log('correspondence language prepared ======> '+ correspondenceLanguage);
    }
    extractPSM(){
        this.showSpinner = true;
        extractPSM()
        .then(result => {
            if(result != null) {
                //console.log('PSM Extracted ===> '+JSON.stringify(result));
                let preparePSMExtractList = [];
                for(let i = 0 ; i < result.length; i++){
                    let preparePSMExtractItem = {};
                    preparePSMExtractItem.Id = result[i].Id;
                    //console.log('Each result ==> '+JSON.stringify(result[i]));
                    preparePSMExtractItem.Name = result[i].Name;
                    if(result[i].hasOwnProperty('ELC_Master_Configuration__r')){
                        if(result[i].ELC_Master_Configuration__r.hasOwnProperty('ELC_Topic_Name__c')){
                            preparePSMExtractItem.Topic = result[i].ELC_Master_Configuration__r.ELC_Topic_Name__c;
                        }
                        if(result[i].ELC_Master_Configuration__r.hasOwnProperty('Name')){
                            preparePSMExtractItem.TopicMC = result[i].ELC_Master_Configuration__r.Name;           
                        }
                    }
                    if(result[i].hasOwnProperty('ELC_Master_Configuration2__r')){
                        if(result[i].ELC_Master_Configuration2__r.hasOwnProperty('ELC_Sub_Topic_Name__c')){
                            preparePSMExtractItem.SubTopic = result[i].ELC_Master_Configuration2__r.ELC_Sub_Topic_Name__c;
                        }
                        if(result[i].ELC_Master_Configuration2__r.hasOwnProperty('Name')){
                            preparePSMExtractItem.SubTopicMC = result[i].ELC_Master_Configuration2__r.Name;  
                        }
                    }
                    preparePSMExtractItem.LinkName = result[i].ELC_Link_name__c;
                    preparePSMExtractItem.ELC_Location__c = result[i].ELC_Location__c;
                    preparePSMExtractItem.ELC_Location_Type__c = result[i].ELC_Location_Type__c;
                    preparePSMExtractItem.ELC_Job_Function__c = result[i].ELC_Job_Function__c;
                    preparePSMExtractItem.ELC_Function__c = result[i].ELC_Function__c;
                    preparePSMExtractItem.ELC_Hierarchy__c = result[i].ELC_Hierarchy__c;
                    preparePSMExtractItem.ELC_Payroll__c = result[i].ELC_Payroll__c;
                    preparePSMExtractItem.ELC_Correspondence_Language__c = result[i].ELC_Correspondence_Language__c;
                    preparePSMExtractItem.Indicator__c = result[i].Indicator__c;
                    preparePSMExtractItem.ELC_Brand__c = result[i].ELC_Brand__c;
                    preparePSMExtractItem.ELC_Additional_Privileges__c = result[i].ELC_Additional_Privileges__c;
                    preparePSMExtractItem.ELC_Links__c = result[i].ELC_Links__c;
                    preparePSMExtractItem.ELC_Links_Order__c = JSON.stringify(result[i].ELC_Links_Order__c);
                    preparePSMExtractItem.ELC_Link_keywords__c = result[i].ELC_Link_keywords__c;
                    preparePSMExtractItem.ELC_Icon_Type__c = result[i].ELC_Icon_Type__c;
                    preparePSMExtractItem.RecordTypeName = result[i].RecordType.Name;
                    preparePSMExtractItem.ELC_MC_External_ID_From_Dev__c = result[i].ELC_MC_External_ID_From_Dev__c;
                    preparePSMExtractList.push(preparePSMExtractItem);
                   //console.log('preparePSMExtractList ==> '+JSON.stringify(preparePSMExtractList));
                }
                this.psmExtract = preparePSMExtractList;
            }
            this.showSpinner = false;
            this.download();
        })
        .catch(error =>{
            console.log('error ===> '+error);
            this.showSpinner = false;
        })
    }
    //this is to download as excel
    schemaObj = [
        { column: 'Id', type: String, value: psmExtract => psmExtract.Id},
        { column: 'Name', type: String, value: psmExtract => psmExtract.Name},
        { column: 'Topic', type: String, value: psmExtract => psmExtract.Topic},
        { column: 'Topic MC', type: String, value: psmExtract => psmExtract.TopicMC},
        { column: 'Sub-Topic', type: String, value: psmExtract => psmExtract.SubTopic},
        { column: 'Sub-Topic MC', type: String, value: psmExtract => psmExtract.SubTopicMC},
        { column: 'Link Name', type: String, value: psmExtract => psmExtract.LinkName},
        { column: 'ELC_Location__c', type: String, value: psmExtract => psmExtract.ELC_Location__c},
        { column: 'ELC_Location_Type__c', type: String, value: psmExtract => psmExtract.ELC_Location_Type__c},
        { column: 'ELC_Job_Function__c', type: String, value: psmExtract => psmExtract.ELC_Job_Function__c},
        { column: 'ELC_Function__c', type: String, value: psmExtract => psmExtract.ELC_Function__c},
        { column: 'ELC_Hierarchy__c', type: String, value: psmExtract => psmExtract.ELC_Hierarchy__c},
        { column: 'ELC_Payroll__c', type: String, value: psmExtract => psmExtract.ELC_Payroll__c},
        { column: 'ELC_Correspondence_Language__c', type: String, value: psmExtract => psmExtract.ELC_Correspondence_Language__c},
        { column: 'Indicator__c', type: String, value: psmExtract => psmExtract.Indicator__c},
        { column: 'ELC_Brand__c', type: String, value: psmExtract => psmExtract.ELC_Brand__c},
        { column: 'ELC_Additional_Privileges__c', type: String, value: psmExtract => psmExtract.ELC_Additional_Privileges__c},
        { column: 'ELC_Links__c', type: String, value: psmExtract => psmExtract.ELC_Links__c},
        { column: 'ELC_Links_Order__c', type: String, value: psmExtract => psmExtract.ELC_Links_Order__c},
        { column: 'ELC_Link_Keywords__c', type: String, value: psmExtract => psmExtract.ELC_Link_keywords__c},
        { column: 'ELC_Icon_Type__c', type: String, value: psmExtract => psmExtract.ELC_Icon_Type__c},
        { column: 'Record Type Name', type: String, value: psmExtract => psmExtract.RecordTypeName},
        { column: 'ELC_MC_External_ID_From_Dev__c', type: String, value: psmExtract => psmExtract.ELC_MC_External_ID_From_Dev__c},

    ]

    renderedCallback() {
        if (this.librariesLoaded) return;
        this.librariesLoaded = true;
        Promise.all(
            loadScript(this, workbook)
        )
            .then(async (data) => {
                //console.log("success------>>>", data);
            })
            .catch(error => {
                //console.log("failure-------->>>>", error);
            });
    }
    async download() {
        let _self = this;
        // When passing `objects` and `schema`.
        await writeXlsxFile(_self.psmExtract, {
            schema: _self.schemaObj,
            fileName: 'PSM Full Extract.xlsx'
        })
    }

    doSorting(event) {
        this.sortBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.listName = event.currentTarget.dataset.id;
        try {

            this.sortData(this.sortBy, this.sortDirection, this.listName);
        } catch(e){
            console.log('error ===> '+e);
        }
    }

    sortData(fieldName, direction, listName) {
        // cheking reverse direction
        let isReverse = direction === 'asc' ? 1: -1;

        let parseData;

        if(listName == 'accessPSMList'){
            parseData = JSON.parse(JSON.stringify(this.accessPSMList));
        } else if(listName == 'noAccessPSMList'){
            parseData = JSON.parse(JSON.stringify(this.noAccessPSMList));
        } else if(listName == 'externalLinkList'){
            parseData = JSON.parse(JSON.stringify(this.externalLinkList));
        } else if(listName == 'trendingOnOneSourceList'){
            parseData = JSON.parse(JSON.stringify(this.trendingOnOneSourceList));
        }
        // Return the value stored in the field
        let keyValue = (a) => {
            return a[fieldName];
        };
        // sorting data
        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : ''; // handling null values
            y = keyValue(y) ? keyValue(y) : '';
            // sorting values based on direction
            return isReverse * ((x > y) - (y > x));
        });
        if(listName == 'accessPSMList'){
            this.accessPSMList = parseData;
        } else if(listName == 'noAccessPSMList'){
            this.noAccessPSMList = parseData;
        } else if(listName == 'externalLinkList'){
            this.externalLinkList = parseData;
        } else if(listName == 'trendingOnOneSourceList'){
            this.trendingOnOneSourceList = parseData;
        }
    }    

    updateAccessSearch(event){
        let regex = new RegExp(event.target.value,'i')
        this.accessPSMList = this.allAccessPSMList.filter(row => {
            if( regex.test(row.ELC_Topic_Name__c) || 
                regex.test(row.ELC_Link_name__c) || 
                regex.test(row.ELC_Sub_Topic_Name__c) || 
                regex.test(row.Name)){
                return row;
            }
        })
        if(!event.target.value){
            this.accessPSMList = [...this.allAccessPSMList];
        }
    }
    updateNoAccessSearch(event){
        let regex = new RegExp(event.target.value,'i')
        this.noAccessPSMList = this.allNoAccessPSMList.filter(row => {
            if( regex.test(row.ELC_Topic_Name__c) || 
                regex.test(row.ELC_Link_name__c) || 
                regex.test(row.ELC_Sub_Topic_Name__c) || 
                regex.test(row.Name)){
                return row;
            }
        })
        if(!event.target.value){
            this.noAccessPSMList = [...this.allNoAccessPSMList];
        }
    }
    updateTrendingOnOneSourceSearch(event){
        let regex = new RegExp(event.target.value,'i')
        this.trendingOnOneSourceList = this.allTrendingOnOneSourceList.filter(row => {
            if( regex.test(row.Name) || 
                regex.test(row.ELC_Link_name__c) || 
                regex.test(row.ELC_Links_Order__c) || 
                regex.test(row.ELC_Job_Function__c) || 
                regex.test(row.ELC_Location__c) || 
                regex.test(row.ELC_Start_Date__c) || 
                regex.test(row.Elc_End_Date__c) || 
                regex.test(row.ELC_Links__c)){
                return row;
            }
        })
        if(!event.target.value){
            this.noAccessPSMList = [...this.allNoAccessPSMList];
        }
    }
}