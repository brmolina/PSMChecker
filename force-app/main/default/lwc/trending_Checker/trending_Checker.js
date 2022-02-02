/*
 * Date             : 25/01/2022
 * Created By       : Bruno Molina
 * Description:     : Custom LWC to filter Trending on OneSource Master Configuration records.
 * User Stories     : OSP-17769
 */
import { track, LightningElement } from 'lwc';
import getLocations from '@salesforce/apex/TrendingCheckerController.getLocations';
import getJobFunction from '@salesforce/apex/TrendingCheckerController.getJobFunction';
import getFunction from '@salesforce/apex/TrendingCheckerController.getFunction';
import searchTrendingArticles from '@salesforce/apex/TrendingCheckerController.searchTrendingArticles';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { loadScript } from "lightning/platformResourceLoader";
import workbook from "@salesforce/resourceUrl/writeExcel";
import USER_PERMISSION from '@salesforce/customPermission/PSMExtractPermission';

const trendingOnOneSourceColumns = [
    { label: 'Name', fieldName: 'url', wrapText: true, hideDefaultActions: true, sortable: "true", type: "url",
        typeAttributes: {label: {fieldName: "Name"}}, initialWidth: 70
    },
    { label: 'Link Name / Form Name', fieldName: 'ELC_Link_name__c', wrapText: true, hideDefaultActions: true, sortable: "true", initialWidth: 300 },
    { label: 'Links Order', fieldName: 'ELC_Links_Order__c', wrapText: true, hideDefaultActions: true, sortable: "true", initialWidth: 80 },
    { label: 'ELC Job Function', fieldName: 'ELC_Job_Function__c', wrapText: true, hideDefaultActions: true, sortable: "true", initialWidth: 110, wrapText: true },
    { label: 'ELC Location', fieldName: 'ELC_Location__c', wrapText: true, hideDefaultActions: true, sortable: "true", initialWidth: 300, wrapText: true },
    { label: 'Link Start Date', fieldName: 'ELC_Start_Date__c', wrapText: true, hideDefaultActions: true, sortable: "true", initialWidth: 100 },
    { label: 'Link End Date', fieldName: 'Elc_End_Date__c', wrapText: true, hideDefaultActions: true, sortable: "true", initialWidth: 90 },
    { label: 'Link (URL)', fieldName: 'ELC_Links__c', wrapText: false, hideDefaultActions: true, sortable: "true", type: "url", initialWidth: 500},

];

export default class Trendindg_Checker extends LightningElement {
    @track inputLocationValue = '';
    @track loadingLocation = false;
    @track noLocationResult = false;
    
    @track inputJobFunctionValue = '';
    @track loadingJobFunction = false;
    @track noJobFunctionResult = false;
    
    @track inputFunctionValue = '';
    @track loadingFunction = false;
    @track noFunctionResult = false;
    
    @track locationItems = [];
    @track jobFunctionItems = [];
    @track functionItems = [];

    @track searchLocationRecords = [];
    @track searchJobFunctionRecords = [];
    @track searchFunctionRecords = [];

    @track activeMC = true;
    @track showSpinner = false;
    @track trendingOnOneSourceList;
    allTrendingOnOneSourceList;
    @track showTrendingList = false;
    @track trendingOnOneSourceColumns = trendingOnOneSourceColumns;

    @track sortBy='ELC_Link_name__c';
    @track sortDirection='asc';

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
        this.showTrendingList = false;
        this.noLocationResult = false;
        this.noJobFunctionResult = false;
        this.noFunctionResult = false;
        this.searchLocationRecords.splice(0,this.searchLocationRecords.length);
        this.searchJobFunctionRecords.splice(0,this.searchJobFunctionRecords.length);
        this.searchFunctionRecords.splice(0,this.searchFunctionRecords.length);
        let eventName = event.target.name;
        //console.log('search Keyword event ==> ', eventName);
        if(eventName == 'inputLocation'){
            this.inputLocationValue = event.target.value;
            if(this.inputLocationValue.length >= 2){
                this.loadingLocation = true;
                getLocations({location: this.inputLocationValue})
                .then(result =>{
                    if(result.length == 0){
                        this.noLocationResult = true;
                    }
                this.loadingLocation = false;
                if(result != null && result.length > 0){
                   // console.log('result ==> ', result);
                    let prepareList = [];
                    for(let i = 0 ; i < result.length; i++){
                            let locationItem = this.locationItems.filter(row => 
                                    row.label == result[i]  
                            );
                            if(locationItem == false){
                                let prepareItem = {};
                                prepareItem.value = result[i];
                                prepareList.push(prepareItem);
                            }
                    }
                    this.searchLocationRecords = prepareList;
                    if(prepareList.length == 0){
                        this.noLocationResult = true;
                    }
                   // console.log('searchLocationRecords ===> '+JSON.stringify(this.searchLocationRecords));
                }
                })      
                .catch(error =>{
                this.loadingLocation = false;
                console.log('error '+error);
                });
            }
        }
        if(eventName == 'inputJobFunction'){
            this.inputJobFunctionValue = event.target.value;
            //console.log('inputJobFunctionValue ==> '+this.inputJobFunctionValue);
            if(this.inputJobFunctionValue.length >= 2){
                this.loadingJobFunction = true;
                //console.log('location values ==> '+JSON.stringify(this.locationItems));
                //locations selected in fist box treated for query
                let locationsForQuery = [];
                let locationsSelected = this.locationItems;
                try{
                    if(locationsSelected.length >0){
                        for(let i = 0; locationsSelected.length; i ++){
                            locationsForQuery.push('\''+locationsSelected[i].label+'\'');
                        }
                    }        

                }catch(e){
                    console.log('error => '+JSON.stringify(e));
                }
                //console.log('locationsForQuery ==> '+ locationsForQuery);
                getJobFunction({jobFunction : this.inputJobFunctionValue, location: locationsForQuery})
                .then(result =>{
                   // console.log('job function result ==> '+JSON.stringify(result));
                    if(result.length == 0){
                        this.noJobFunctionResult = true;
                    }
                this.loadingJobFunction = false;
                if(result != null && result.length > 0){
                    //console.log('result ==> ', result);
                    let prepareList = [];
                    for(let i = 0 ; i < result.length; i++){
                            let jobFunctionItem = this.jobFunctionItems.filter(row => 
                                    row.label == result[i]  
                            );
                            if(jobFunctionItem == false){
                                let prepareItem = {};
                                prepareItem.value = result[i];
                                prepareList.push(prepareItem);
                            }
                    }
                    this.searchJobFunctionRecords = prepareList;
                    if(prepareList.length == 0){
                        this.noJobFunctionResult = true;
                    }
                }
                })
                .catch(error =>{
                    this.loadingJobFunction = false;
                    console.log('error '+JSON.stringify(error));
                });
            }
        }
        if(eventName == 'inputFunction'){
                this.inputFunctionValue = event.target.value;
                //console.log('input function value ==> '+this.inputFunctionValue);
                if(this.inputFunctionValue.length >= 2){
                    this.loadingFunction = true;
                    //locations selected in fist box treated for query
                    let locationsForQuery = [];
                    let locationsSelected = this.locationItems;
                        if(locationsSelected.length >0){
                            try{
                                for(let i = 0; locationsSelected.length; i ++){
                                    locationsForQuery.push('\''+locationsSelected[i].label+'\'');
                                }
                            }
                            catch(error){
                                this.loadingFunction = false;
                                console.log('error '+JSON.stringify(error));
                            }
                        }        
                    //console.log('locationsForQuery ==> '+ locationsForQuery);
                    getFunction({function : this.inputFunctionValue, location: locationsForQuery})
                    .then(result => {
                        //console.log('function result ==> '+JSON.stringify(result));
                        if(result.length == 0){
                            this.noFunctionResult = true;
                        }
                    this.loadingFunction = false;
                    if(result != null && result.length > 0){
                        //console.log('result ==> ', result);
                        let prepareList = [];
                        for(let i = 0 ; i < result.length; i++){
                                let functionItem = this.functionItems.filter(row => 
                                        row.label == result[i]  
                                );
                                if(functionItem == false){
                                    let prepareItem = {};
                                    prepareItem.value = result[i];
                                    prepareList.push(prepareItem);
                                }
                        }
                        this.searchFunctionRecords = prepareList;
                        if(prepareList.length == 0){
                            this.noFunctionResult = true;
                        }
                    }
                    })
                    .catch(error =>{
                        this.loadingFunction = false;
                        console.log('error '+JSON.stringify(error));
                    });
                    
                }
        }
    }

    addSearchValueList(event){
        var value = event.currentTarget.dataset.value;
        var listName = event.currentTarget.dataset.listname;
        //console.log('listName ==> '+listName);
        //console.log('current target dataset ==> '+JSON.stringify(event.currentTarget.dataset));
        if(value != null){
            if(listName == 'locationList'){
                let inputLocationItem = {};
                inputLocationItem.label = value;
                inputLocationItem.listName = 'inputLocation';
                this.locationItems.push(inputLocationItem);   
            }
            if(listName == 'jobFunctionList'){
                let inputJobFunctionItem = {};
                inputJobFunctionItem.label = value;
                inputJobFunctionItem.listName = 'inputJobFunction';
                this.jobFunctionItems.push(inputJobFunctionItem);
            }
            if(listName == 'functionList'){
                let inputFunctionItem = {};
                inputFunctionItem.label = value;
                inputFunctionItem.listName = 'inputFunction';
                this.functionItems.push(inputFunctionItem);
            }
        }

        
    }

    clearValues(event){
        this.showTrendingList = false;
            let eventName = event.target.name;
            //console.log('event target label ', eventName);
            if(eventName == 'inputLocation'){
                this.inputLocationValue = '';
                this.noLocationResult = false;
                setTimeout(() => {this.searchLocationRecords.length = 0}, 300);
                
            }
            if(eventName == 'inputJobFunction'){
                this.inputJobFunctionValue = '';
                this.noJobFunctionResult = false;
                setTimeout(() => {this.searchJobFunctionRecords.length = 0}, 300);
            }
            if(eventName == 'inputFunction'){
                this.inputFunctionValue = '';
                this.noFunctionResult = false;
                setTimeout(() => {this.searchFunctionRecords.length = 0}, 300);
                
            }

    }

    handleItemRemove(event) {
        this.showTrendingList = false;
        const index = event.detail.index;
        let listName = event.detail.item.listName;
        if(listName == 'inputLocation'){
            this.locationItems.splice(index, 1);
        }
        if(listName == 'inputJobFunction'){
            this.jobFunctionItems.splice(index, 1);
        }
        if(listName == 'inputFunction'){
            this.functionItems.splice(index, 1);
        }
    }
    changeMCToggle(){
        this.showTrendingList = false;
        this.activeMC = !this.activeMC;
        //console.log('Active MC => '+this.activeMC);
    }
    handleSearchTrendingArticles(){
        this.showTrendingList = false;
        this.showSpinner = true;
        //console.log('this.locationItems ==> '+JSON.stringify(this.locationItems));
       // console.log('this.jobFunctionItems ==> '+JSON.stringify(this.jobFunctionItems));
        //console.log('this.functionItems ==> '+JSON.stringify(this.functionItems));
        //console.log('this.activeMC ==> '+JSON.stringify(this.activeMC));
        let isInactive = !this.activeMC;
        //treating Location values
        let locationsForQuery = [];
        let locationsSelected = this.locationItems;
        if(locationsSelected.length >0){
            try{
                for(let i = 0; locationsSelected.length; i ++){
                    locationsForQuery.push('\''+locationsSelected[i].label+'\'');
                }
            }
            catch(error){
                this.showSpinner = false;
                console.log('error '+JSON.stringify(error));
            }
        }
       // console.log('locationsForQuery => '+locationsForQuery);
        //treating Job Function values
        let jobFunctionsForQuery = [];
        let jobFunctionsSelected = this.jobFunctionItems;
            if(jobFunctionsSelected.length >0){
                try{
                    for(let i = 0; jobFunctionsSelected.length; i ++){
                        jobFunctionsForQuery.push('\''+jobFunctionsSelected[i].label+'\'');
                    }
                }
                catch(error){
                    this.showSpinner = false;
                    console.log('error '+JSON.stringify(error));
                }
            }
        //console.log('jobFunctionsForQuery => '+jobFunctionsForQuery);
        //treating Function values
        let functionsForQuery = [];
        let functionsSelected = this.functionItems;
            if(functionsSelected.length >0){
                try{
                    for(let i = 0; functionsSelected.length; i ++){
                        functionsForQuery.push('\''+functionsSelected[i].label+'\'');
                    }
                }
                catch(error){
                    this.showSpinner = false;
                    console.log('error '+JSON.stringify(error));
                }
            }
            //console.log('functionsForQuery => '+functionsForQuery);
            searchTrendingArticles({locationItems: locationsForQuery, jobFunctionItems: jobFunctionsForQuery, functionItems: functionsForQuery, isInactive: isInactive})
            .then(result => {
            this.showSpinner = false;
            //console.log('Trending Articles search result => '+JSON.stringify(result));
            if(result != null){
                let psmList = result;
                let prepareTrendingOnOneSourceList = [];
                    for(let i = 0 ; i < psmList.length; i++){
                       let prepareTrendingOnOneSourceItem = {}
                       
                        prepareTrendingOnOneSourceItem.Id = psmList[i].Id;
                        prepareTrendingOnOneSourceItem.Name = psmList[i].Name;
                        prepareTrendingOnOneSourceItem.ELC_Links_Order__c = psmList[i].ELC_Links_Order__c;
                        prepareTrendingOnOneSourceItem.ELC_Links_Order__c_String = JSON.stringify(psmList[i].ELC_Links_Order__c);
                        prepareTrendingOnOneSourceItem.ELC_Link_keywords__c = psmList[i].ELC_Link_keywords__c;
                        prepareTrendingOnOneSourceItem.url = '/'+psmList[i].Id;
                        prepareTrendingOnOneSourceItem.ELC_Topic_Name__c = psmList[i].ELC_Master_Configuration__r.ELC_Topic_Name__c;
                        prepareTrendingOnOneSourceItem.TopicMC = psmList[i].ELC_Master_Configuration__r.Name;
                        prepareTrendingOnOneSourceItem.ELC_Link_name__c = psmList[i].ELC_Link_name__c;
                        prepareTrendingOnOneSourceItem.ELC_Links__c = psmList[i].ELC_Links__c;
                        prepareTrendingOnOneSourceItem.ELC_Job_Function__c = psmList[i].ELC_Job_Function__c;
                        prepareTrendingOnOneSourceItem.ELC_Hierarchy__c = psmList[i].ELC_Hierarchy__c;
                        prepareTrendingOnOneSourceItem.ELC_Location__c = psmList[i].ELC_Location__c;
                        prepareTrendingOnOneSourceItem.ELC_Location_Type__c = psmList[i].ELC_Location_Type__c;
                        prepareTrendingOnOneSourceItem.ELC_Payroll__c = psmList[i].ELC_Payroll__c;
                        prepareTrendingOnOneSourceItem.ELC_Correspondence_Language__c = psmList[i].ELC_Correspondence_Language__c;
                        prepareTrendingOnOneSourceItem.Indicator__c = psmList[i].Indicator__c;
                        prepareTrendingOnOneSourceItem.ELC_Brand__c = psmList[i].ELC_Brand__c;
                        prepareTrendingOnOneSourceItem.ELC_Additional_Privileges__c = psmList[i].ELC_Additional_Privileges__c;
                        prepareTrendingOnOneSourceItem.ELC_Icon_Type__c = psmList[i].ELC_Icon_Type__c;
                        prepareTrendingOnOneSourceItem.RecordTypeName = psmList[i].RecordType.Name;
                        prepareTrendingOnOneSourceItem.ELC_Start_Date__c = psmList[i].ELC_Start_Date__c;
                        prepareTrendingOnOneSourceItem.Elc_End_Date__c = psmList[i].Elc_End_Date__c;
                        prepareTrendingOnOneSourceItem.ELC_MC_External_ID_From_Dev__c = psmList[i].ELC_MC_External_ID_From_Dev__c;
                        prepareTrendingOnOneSourceItem.listName = 'trendingOnOneSourceList';
    
                        if(psmList[i].hasOwnProperty('ELC_Master_Configuration2__r')){
                            if(psmList[i].ELC_Master_Configuration2__r.hasOwnProperty('ELC_Sub_Topic_Name__c')){
                            prepareTrendingOnOneSourceItem.ELC_Sub_Topic_Name__c = psmList[i].ELC_Master_Configuration2__r.ELC_Sub_Topic_Name__c;
                            prepareTrendingOnOneSourceItem.SubTopicMC = psmList[i].ELC_Master_Configuration2__r.Name;
                            }
                        }
                        prepareTrendingOnOneSourceList.push(prepareTrendingOnOneSourceItem);
                    }
                this.trendingOnOneSourceList = prepareTrendingOnOneSourceList;
                this.allTrendingOnOneSourceList = prepareTrendingOnOneSourceList;
                this.showTrendingList = true;
                const event = new ShowToastEvent({
                    title: 'Trending Articles found',
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
        })
        .catch(error => {
            console.log('error '+JSON.stringify(error));
        })
        
    }
    doSorting(event) {
        this.sortBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.listName = event.currentTarget.dataset.id;
        try {
            this.sortData(this.sortBy, this.sortDirection, this.listName);
        } catch(e){
            console.log('error ===> ',e);
        }
    }

    sortData(fieldName, direction, listName) {
        // cheking reverse direction
        let isReverse = direction === 'asc' ? 1: -1;

        let parseData;

        if(listName == 'trendingOnOneSourceList'){
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
        if(listName == 'trendingOnOneSourceList'){
            this.trendingOnOneSourceList = parseData;
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
            this.trendingOnOneSourceList = [...this.allTrendingOnOneSourceList];
        }
    }
    //this is to download as excel
    schemaObj = [
        { column: 'Id', type: String, value: trendingOnOneSourceList => trendingOnOneSourceList.Id},
        { column: 'Name', type: String, value: trendingOnOneSourceList => trendingOnOneSourceList.Name},
        { column: 'Topic', type: String, value: trendingOnOneSourceList => trendingOnOneSourceList.ELC_Topic_Name__c},
        { column: 'Topic MC', type: String, value: trendingOnOneSourceList => trendingOnOneSourceList.TopicMC},
        { column: 'Sub-Topic', type: String, value: trendingOnOneSourceList => trendingOnOneSourceList.ELC_Sub_Topic_Name__c},
        { column: 'Sub-Topic MC', type: String, value: trendingOnOneSourceList => trendingOnOneSourceList.SubTopicMC},
        { column: 'Link Name', type: String, value: trendingOnOneSourceList => trendingOnOneSourceList.ELC_Link_name__c},
        { column: 'ELC_Location__c', type: String, value: trendingOnOneSourceList => trendingOnOneSourceList.ELC_Location__c},
        { column: 'ELC_Location_Type__c', type: String, value: trendingOnOneSourceList => trendingOnOneSourceList.ELC_Location_Type__c},
        { column: 'ELC_Job_Function__c', type: String, value: trendingOnOneSourceList => trendingOnOneSourceList.ELC_Job_Function__c},
        { column: 'ELC_Function__c', type: String, value: trendingOnOneSourceList => trendingOnOneSourceList.ELC_Function__c},
        { column: 'ELC_Hierarchy__c', type: String, value: trendingOnOneSourceList => trendingOnOneSourceList.ELC_Hierarchy__c},
        { column: 'ELC_Payroll__c', type: String, value: trendingOnOneSourceList => trendingOnOneSourceList.ELC_Payroll__c},
        { column: 'ELC_Correspondence_Language__c', type: String, value: trendingOnOneSourceList => trendingOnOneSourceList.ELC_Correspondence_Language__c},
        { column: 'Indicator__c', type: String, value: trendingOnOneSourceList => trendingOnOneSourceList.Indicator__c},
        { column: 'ELC_Brand__c', type: String, value: trendingOnOneSourceList => trendingOnOneSourceList.ELC_Brand__c},
        { column: 'ELC_Additional_Privileges__c', type: String, value: trendingOnOneSourceList => trendingOnOneSourceList.ELC_Additional_Privileges__c},
        { column: 'ELC_Links__c', type: String, value: trendingOnOneSourceList => trendingOnOneSourceList.ELC_Links__c},
        { column: 'ELC_Links_Order__c', type: String, value: trendingOnOneSourceList => trendingOnOneSourceList.ELC_Links_Order__c_String},
        { column: 'ELC_Link_Keywords__c', type: String, value: trendingOnOneSourceList => trendingOnOneSourceList.ELC_Link_keywords__c},
        { column: 'ELC_Icon_Type__c', type: String, value: trendingOnOneSourceList => trendingOnOneSourceList.ELC_Icon_Type__c},
        { column: 'Record Type Name', type: String, value: trendingOnOneSourceList => trendingOnOneSourceList.RecordTypeName},
        { column: 'ELC_MC_External_ID_From_Dev__c', type: String, value: trendingOnOneSourceList => trendingOnOneSourceList.ELC_MC_External_ID_From_Dev__c},

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
        await writeXlsxFile(_self.trendingOnOneSourceList, {
            schema: _self.schemaObj,
            fileName: 'Trending Articles Extract.xlsx'
        })
    }
}