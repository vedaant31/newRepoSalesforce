import { LightningElement, wire, track, api } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { fireEvent, registerListener } from 'c/pubsub';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import saveAccounts from '@salesforce/apex/AccountController.saveAccounts';
import getPickList from '@salesforce/apex/AccountPicklist.getPickList';

export default class AppEventChild extends LightningElement {
    @wire(CurrentPageReference) pageRef;
    objApi = 'Account';
    fieldApi = 'Type';
    typeOptions = [];
    checkRead = false;
    checkcancel = false;
    afterSave = false;
    @track rows = [];
    @track TableFields = [];
    allRows;
    @track newData = [];
    newT = false;
    constructor() {
        super();
        this.rows.push(this.createEmptyRow());
    }
    @wire(getPickList, { objApi: '$objApi', fieldApi: '$fieldApi' })
    wiredPicklistValues({ error, data }) {
        if (data) {
            this.typeOptions = data.map(element => ({ label: element, value: element }));
        } else if (error) {
            console.error('Error retrieving picklist values: ', error);
        }
    }

    addRow() {
        console.log('hi entered addRow');
        const newRow = {
            key: this.generateKey(),
            accountName: '',
            accountNumber: '',
            phone: '',
            type: '',
            Id: ''
        }
        this.rows = [...this.rows, newRow];
        this.checkRead = false;
        this.afterSave = false;
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

        if (this.checkRead == false) {
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
                    const tableFieldValues = result;
                    this.allRows = tableFieldValues
                    console.log("these are tablefield values which have to sent----------------->", tableFieldValues);
                    this.checkRead = true;
                    this.afterSave = true;
                    fireEvent(this.pageRef, 'tablefieldsevent', tableFieldValues);

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

    connectedCallback() {
        registerListener('tableupdatedevent', this.handleEvent, this);
    }

    handleEvent(allValues) {
        this.newT = true;
        this.newData = allValues; // Assuming allValues is already an array of objects
        console.log("allvalues table", JSON.stringify(this.newData));
        this.newData.forEach(item => {
            console.log("name is", item.Name);
        });
        console.log("hi");
        console.log(allValues);
        console.log(this.newData);
    
        const DATA = this.newData.map(item => ({
            Name: item.Name,
            AccountNumber: item.AccountNumber,
            Id: item.Id,
            Phone: item.Phone,
            Type: item.Type
        }));
    
        console.log("value is", DATA);
    }
    
    

    cancelRecord() {
        this.checkRead = false;
        this.checkcancel = true;
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