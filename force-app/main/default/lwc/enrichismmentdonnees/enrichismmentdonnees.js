import { LightningElement, api, wire } from 'lwc';
import { getRecord } from "lightning/uiRecordApi";
import URIPappersEntreprise from "@salesforce/label/c.URIPappersEntreprise";
import ApiTokenPappers from "@salesforce/label/c.ApiTokenPappers";

const ACCOUNT_FIELDS = ["Account.Id","Account.Name","Account.Siret__c","Account.SIREN__c"];

export default class Enrichismmentdonnees extends LightningElement {

    @api recordId;
    @api objectApiName;
    MY_TOKEN = ApiTokenPappers;
    URL_BASE = URIPappersEntreprise;

    get fields() {
            return ACCOUNT_FIELDS;
    }

    @wire(getRecord,{recordId: "$recordId", fields: "$fields"})
    handlegetAccId({error, data}){
        console.log('===> data from account', data)
         console.log('===> data account', data?.fields?.Siret__c?.value);
         let input = data?.fields?.Siret__c?.value;
         if(input){
           this.fetchPappersData(input);
         }
    }
    fetchPappersData(input){
        const requestParams = {

            method:'GET',
            headers: {
                'Content-Type': 'application/json; charset=utf-8'
            }
        }
        const endpoint = this.URL_BASE+'?api_token='+this.MY_TOKEN+'&siren=' +input;
        fetch(endpoint, requestParams)
        .then(response =>  {
            console.log('response of call ', response)
            if(!response.ok){
                throw new Error('Network response was not Ok')
            }
            return response.json();
        }).then(data =>{
            console.log('data from response ==> ',data);
        }).catch(error => {
            console.log('error de recuperation pappers', error)
        })

    }
}