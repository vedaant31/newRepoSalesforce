import { LightningElement, wire, track } from 'lwc';
import { subscribe, MessageContext } from 'lightning/messageService';
import SAMPLE_MESSAGE_CHANNEL from '@salesforce/messageChannel/SampleMessageChannel__c';
import fetchRecords from '@salesforce/apex/fetchRecordsController.fetchRecords';

export default class LwcReceiver extends LightningElement {
    subscription = null;
    fields = [];
    accName = '';
    showtable = false;
    records = [];
    error;
    @track columns = [];
    tree1=[];
    tree2=[];
    @track data = [];

    @wire(MessageContext)
    messageContext;

    connectedCallback() {
        this.subscribeToMessageChannel();
    }

    subscribeToMessageChannel() {
        if (!this.subscription) {
            this.subscription = subscribe(this.messageContext, SAMPLE_MESSAGE_CHANNEL, (message) => {
                this.handleMessage(message);
            });
        }
    }

    handleMessage(message) {
        console.log('Received message in LWC:', message);
        const selectedFields = message.selectedFields;
        const objectName = message.objName;

        this.fields = selectedFields;
        this.accName = objectName;
        console.log('Fields value:', this.fields);
    }

    @wire(fetchRecords, { objectName: '$accName', fieldNames: '$fields' })
    wiredRecords({ error, data }) {
        console.log('Wired records');
        if (data) {
            this.records = data;
            this.error = undefined;
            console.log('Final records:', JSON.stringify(this.records));
            this.processRecords();
            this.showtable = true;
        } else if (error) {
            this.error = error;
            this.records = undefined;
            console.log('Error:', error);
        }
    }

    processRecords() {

        const temp1 = Object.keys(this.records[0]);
        this.tree1=temp1;
        

const temp2 = this.records.map(obj => Object.values(obj));
this.tree2=temp2;

console.log("Field Names:", JSON.stringify(temp1));
console.log("Records:", JSON.stringify(temp2));
      
    }
}