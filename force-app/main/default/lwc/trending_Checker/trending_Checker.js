/*
 * Date             : 25/01/2022
 * Created By       : Bruno Molina
 * Description:     : Custom LWC to filter Trending on OneSource Master Configuration records.
 * User Stories     : OSP-17769
 */
import { track, LightningElement } from 'lwc';
import getLocations from '@salesforce/apex/TrendingCheckerController.getLocations';
import getJobFunction from '@salesforce/apex/TrendingCheckerController.getJobFunction';

export default class Trendindg_Checker extends LightningElement {
    @track inputLocationValue = '';
    @track loadingLocation = false;
    @track noLocationResult = false;

    @track inputJobFunctionValue = '';
    @track functionValue = '';
    @track correspondenceLanguageValue = '';
    
    @track locationItems = [];
    @track jobFunctionItems = [];
    @track functionItems = [];
    @track correspondenceLanguageItems = [];

    @track searchLocationRecords = [];

    searchKeyword(event) {
        this.noLocationResult = false;
        this.searchLocationRecords.splice(0,this.searchLocationRecords.length);
        let eventName = event.target.name;
        console.log('search Keyword event ==? ', eventName);
        if(eventName == 'inputLocation'){
            this.inputLocationValue = event.target.value;
            //  let location = this.inputLocationValue;
            if(this.inputLocationValue.length >= 2){
                this.loadingLocation = true;
                getLocations({location: this.inputLocationValue})
                .then(result =>{
                    if(result.length == 0){
                        this.noLocationResult = true;
                    }
                this.loadingLocation = false;
                if(result != null && result.length > 0){
                    console.log('result ==> ', result);
                    let prepareList = [];
                    for(let i = 0 ; i < result.length; i++){
                            console.log('result each == > '+ result[i])
                            console.log('location == > '+ this.inputLocationValue)
                            console.log('Location Items ==> '+JSON.stringify(this.locationItems));
                            let locationItem = this.locationItems.filter(row => 
                                    row.label == result[i]  
                            );
                            console.log('locationItem ===> '+ locationItem);
                            if(locationItem == false){
                                let prepareItem = {};
                                prepareItem.recId = result[i];
                                prepareItem.recName = result[i];
                                prepareList.push(prepareItem);
                            }
                    }
                    this.searchLocationRecords = prepareList;
                    console.log('searchLocationRecords ===> '+JSON.stringify(this.searchLocationRecords));
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
        }
        if(eventName == 'inputFunction'){
            this.functionValue = event.target.value;
        }
        if(eventName == 'inputCorrespondenceLanguage'){
            this.correspondenceLanguageValue = event.target.value;
        }
    }

    addSearchValueList(event){
        var recId = event.currentTarget.dataset.id;
        if(recId != null){
            let inputLocationItem = {};
            inputLocationItem.label = recId;
            inputLocationItem.listName = 'inputLocation';
            this.locationItems.push(inputLocationItem);   
           // this.searchLocationRecords.splice(0,this.searchLocationRecords.length);
        }
    //    this.inputLocationValue = '';
        
    }

    clearValues(event){
            let eventName = event.target.name;
            console.log('event target label ', eventName);
            if(eventName == 'inputLocation'){
                this.inputLocationValue = '';
                this.noLocationResult = '';
                setTimeout(() => {this.searchLocationRecords.length = 0}, 100);

            }
            if(eventName == 'inputJobFunction'){
                let inputJobFunctionItem = {};
                inputJobFunctionItem.label = event.target.value;
                inputJobFunctionItem.listName = 'inputJobFunction';
                this.jobFunctionItems.push(inputJobFunctionItem);
                this.inputJobFunctionValue = '';
            }
            if(eventName == 'inputFunction'){
                let inputFunctionItem = {};
                inputFunctionItem.label = event.target.value;
                inputFunctionItem.listName = 'inputFunction';
                this.functionItems.push(inputFunctionItem);
                this.functionValue = '';
            }
            if(eventName == 'inputCorrespondenceLanguage'){
                let inputCorrespondenceLanguageItem = {};
                inputCorrespondenceLanguageItem.label = event.target.value;
                inputCorrespondenceLanguageItem.listName = 'inputCorrespondenceLanguage';
                this.correspondenceLanguageItems.push(inputCorrespondenceLanguageItem);
                this.correspondenceLanguageValue = '';
            }

    }

    handleItemRemove(event) {
        const index = event.detail.index;
        let listName = event.detail.item.listName;
        if(listName == 'inputLocation'){
            this.locationItems.splice(index, 1);
            this.inputLocationValue = '';
            this.searchLocationRecords.splice(0,this.searchLocationRecords.length);
        }
        if(listName == 'inputJobFunction'){
            this.jobFunctionItems.splice(index, 1);
        }
        if(listName == 'inputFunction'){
            this.functionItems.splice(index, 1);
        }
        if(listName == 'inputCorrespondenceLanguage'){
            this.correspondenceLanguageItems.splice(index, 1);
        }
        //alert(name + ' pill was removed!');
    }
}