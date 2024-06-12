import { LightningElement, track,wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import saveAccounts from '@salesforce/apex/AccountController.saveAccounts';
import getPickList from '@salesforce/apex/AccountPicklist.getPickList';




export default class getFields extends LightningElement {

    objApi = 'Account'; 
    fieldApi = 'Type'; 
    typeOptions = [];
    checkRead=false;
    checkcancel=false;

@track rows = [];
@track TableFields=[];


    TableColumns = [{
        label: 'Name',
        fieldName: 'Name',
        type: 'text',
        sortable: true
    },
    {
        label: 'Account Number',
        fieldName: 'Account_Number',
        type: 'text',
        sortable: true
    },
    {
        label: 'Phone',
        fieldName: 'Phone',
        type: 'Phone',
        sortable: true
    },
    {
        label: 'Type',
        fieldName: 'Type',
        type: 'picklist',
        sortable: true
    },
];
    
   
    constructor() {
        super();
        this.rows.push(this.createEmptyRow());
    }
    
    @wire(getPickList, {objApi: '$objApi', fieldApi: '$fieldApi'})
    wiredPicklistValues({ error, data }) {
        if (data) {
            this.typeOptions =  data.map(element => ({ label: element, value: element }));
        } else if (error) {
            console.error('Error retrieving picklist values: ', error);
        }
    }

    addRow() {
        console.log('hi entered addRow');
        const newRow = {key: this.generateKey(),
        accountName: '',
        accountNumber: '',
        phone: '',
        type: ''}
        this.rows = [...this.rows, newRow];
        this.checkRead=false;
    }
   
    handleInputChange(event) {
        const { key, field } = event.target.dataset;
        const value = event.target.value;
        const updatedRows = this.rows.map(row => {
            if (row.key === key) {
                return { ...row, [field]: value };
            }
            return row;
        });
        this.rows = updatedRows;
    }

    handleTypeChange(event) {
        const { key } = event.target.dataset;
        const value = event.target.value;
        const updatedRows = this.rows.map(row => {
            if (row.key === key) {
                return { ...row, type: value };
            }
            return row;
        });
        this.rows = updatedRows;
    }

    deleteRow(event) {
        const keyToDelete = event.target.dataset.key;
        this.rows = this.rows.filter(row => row.key !== keyToDelete);
    }

    saveRecord() {
        const hasMissingAccountName = this.rows.some(row => !row.accountName);

        if (hasMissingAccountName) {
            const e = new ShowToastEvent({
                title: 'Error',
                message: 'Please provide an Account Name before saving.',
                variant: 'error',
            });
            this.dispatchEvent(e);
            return;
        }

        const accountsToSave = this.rows.map(row => {
            return {
                Name: row.accountName,
                AccountNumber: row.accountNumber,
                Phone: row.phone,
                Type: row.type
            };
        });
        console.log("we are here and value is" + accountsToSave);



        if(this.checkRead==false){
        saveAccounts({ accounts: accountsToSave })
            .then(result => {
                const e = new ShowToastEvent({
                    title: 'Success!',
                    message: 'Records inserted successfully.',
                    variant: 'success',
                });
                this.dispatchEvent(e);
                console.log('Accounts saved:', result);

                this.TableFields = result.map(account => {
                return {
                    Name: account.Name,
                    Account_Number: account.AccountNumber,
                    Phone: account.Phone,
                    Type: account.Type
                };
            });
                this.checkRead=true;
            })
            .catch(error => {
                const e = new ShowToastEvent({
                    title: 'Failure',
                    message: 'Error saving records: ' + error.body.message,
                    variant: 'error',
                });
                this.dispatchEvent(e);
                console.error('Error saving accounts:', error);
            });
        }
    }


    cancelRecord() {
        this.checkRead=false;
        this.checkcancel=true;
        this.resetRows();

    }

    resetRows() {
        this.rows = [this.createEmptyRow()];
    }

    createEmptyRow() {
        return {
            key: this.generateKey(),
            accountName: '',
            accountNumber: '',
            phone: '',
            type: ''
        };
    }

    generateKey() {
        return Math.random().toString(36);
    }
}