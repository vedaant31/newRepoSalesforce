import { LightningElement, wire, track } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { updateRecord } from "lightning/uiRecordApi";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { registerListener, fireEvent } from 'c/pubsub';
import { getRecords } from 'lightning/uiRecordApi';

import NAME_FIELD from '@salesforce/schema/Account.Name';
import PHONE_FILED from '@salesforce/schema/Account.Phone';
import TYPE_FILED from '@salesforce/schema/Account.Type';
import ACCOUNTNUMBER_FILED from '@salesforce/schema/Account.AccountNumber';
import getRecordData from '@salesforce/apex/RecordDataController.getRecordData';
import getPickList from '@salesforce/apex/AccountPicklist.getPickList';



export default class AppEventParent extends LightningElement
 {
    @track tableFields = [];
    @track tableFieldValues = [];
    draftValues = [];
    updatedValues = [];
    @track allValues=[];
    recordIdSet=[];
    typeOptions = [];





  
    @wire(CurrentPageReference) pageRef;

    connectedCallback() {
        registerListener('tablefieldsevent', this.handleEvent, this);
    }

    // @wire(getRecords, {
    //     records: [
    //         {
    //           recordIds: recordIdSet,
    //           fields: [NAME_FIELD,TYPE_FILED,PHONE_FILED,ACCOUNTNUMBER_FILED]
    //         }
    //     ]
    // }) wiredRecords;
    // wiredRecordsHandler({ error, data }) {
    //     if (data) {
    //         this.wiredRecords = data;
    //         console.log("value of wiredRecords",this.wiredRecords);
    //         // You can now access the records via this.wiredRecords in your component
    //     } else if (error) {
    //         // Handle error
    //     }
    // }

    @wire(getPickList, { objApi: '$objApi', fieldApi: '$fieldApi' })
    wiredPicklistValues({ error, data }) {
        if (data) {
            this.typeOptions = data.map(element => ({ label: element, value: element }));
        } else if (error) {
            console.error('Error retrieving picklist values: ', error);
        }
    }
    myfn()
    {
        console.log("picklist values", this.typeOptions);
    }
    
    

    handleEvent(tableFieldValues) {
        console.log('Received table field values:', tableFieldValues);
        this.tableFields = tableFieldValues;
        console.log("last check", JSON.stringify(tableFields));
    }

    TableColumns = [
        { label: 'Name', fieldName: 'Name', type: 'text', editable: true },
        { label: 'Account Number', fieldName: 'AccountNumber', type: 'text', editable: true },
        { label: 'Phone', fieldName: 'Phone', type: 'Phone', editable: true },
        { label: 'Type', fieldName: 'Type', type: 'picklist', editable: true,typeAttributes: { options: '$typeOptions' } },
    ];

    async handleSave(event) {
        console.log('Draft Values:', event.detail.draftValues);
        const val=event.detail.draftValues;

        const records = event.detail.draftValues.map(draftValue => {
            return { fields: { ...draftValue } };
        });
        this.draftValues = [];

        try {
            const recordUpdatePromises = records.map(record => updateRecord(record));
            await Promise.all(recordUpdatePromises);

            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Records updated successfully',
                    variant: 'success',
                })
            );

            console.log('Updated Table Data:',val);
            this.fetchData();

        } catch (error) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error updating records',
                    message: error.body.message,
                    variant: 'error',
                })
            );
        }
    }
    fetchData()
    {
        this.allValues = []; 

       const fetchDataPromises= this.tableFields.map(acc => {
        console.log("Id",acc.Id);
        this.recordIdSet.push(acc.Id);
            return getRecordData({ recordId: acc.Id })
                .then(data => {
                    if (data) {
                        this.allValues.push(data);
                        console.log('Fetched Record Data:', data);
                        
                        console.log('Fetched Record Id:', data.Id);

                        console.log('all values array', JSON.stringify(this.allValues));
                    }
                })
                .catch(error => {
                    console.error('Error fetching record data:', error);
                });
        });

        Promise.all(fetchDataPromises).then(() => {
            console.log('All fetched record data:', JSON.stringify(this.allValues));
            console.log("event fired",this.allValues);
            fireEvent(this.pageRef, 'tableupdatedevent', this.allValues);
            console.log("record Ids",JSON.stringify(this.recordIdSet));




        });
    }

    handleCancel(event) {
        this.draftValues = [];
    }
}