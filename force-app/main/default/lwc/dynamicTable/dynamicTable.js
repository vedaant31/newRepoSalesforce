import { LightningElement, track,api } from 'lwc';
import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import NAME_FIELD from '@salesforce/schema/Account.Name';
import ACCOUNTNUMBER_FIELD from '@salesforce/schema/Account.AccountNumber';
import PHONE_FIELD from '@salesforce/schema/Account.Phone';
import saveAccounts from '@salesforce/apex/accController.saveAccounts';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class DynamicTable extends LightningElement
{
    @track accountList = []; 
    @track index = 0;
    @api recordId;
    @track name = NAME_FIELD;
    @track accNumber = ACCOUNTNUMBER_FIELD;
    @track phone = PHONE_FIELD;
    isLoaded = false;
    AccSaved=false;
    @api record = {
        firstName : '',
        lastName : '',
        Email : '',
        Phone : '',
        Title : ''
    }
    acc = {
        Name : this.name,
        AccountNumber : this.accNumber,
        Phone : this.phone ? this.phone : "",
        key : ''
    }
    addRow(){
        this.index++;
        var i = this.index;
        this.acc.key = i;
        this.accountList.push(JSON.parse(JSON.stringify(this.acc)));
        console.log('Enter ',this.accountList);
        this.AccSaved=false;
    }
    removeRow(event){
        this.isLoaded = true;
        var selectedRow = event.currentTarget;
        var key = selectedRow.dataset.id;
        if(this.accountList.length>1){
            this.accountList.splice(key, 1);
            this.index--;
            this.isLoaded = false;
        }else if(this.accountList.length == 1){
            this.accountList = [];
            this.index = 0;
            this.isLoaded = false;
        }
    } 
    handleNameChange(event) {
        var selectedRow = event.currentTarget;
        var key = selectedRow.dataset.id;
        this.accountList[key].Name = event.target.value;
     
    }
    handleAccountNumberChange(event) {
        var selectedRow = event.currentTarget;
        var key = selectedRow.dataset.id;
        this.accountList[key].AccountNumber = event.target.value;
    }
    handlePhoneChange(event) {
        var selectedRow = event.currentTarget;
        var key = selectedRow.dataset.id;
        this.accountList[key].Phone = event.target.value;
    }

    saveRecord(){        
        saveAccounts({accList : this.accountList})
            .then(result => {
                this.message = result;
                this.error = undefined;
                if(this.message !== undefined) {
                    this.acc.Name = '';
                    this.acc.AccountNumber = '';
                    this.acc.Phone = '';
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'Account created successfully',
                            variant: 'success',
                        }),
                    );
                }
                this.AccSaved=true;
                console.log("this is list",this.accountList[0]);
                console.log(JSON.stringify(result));
                console.log("result", this.message);
            })
            .catch(error => {
                this.message = undefined;
                this.error = error;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error creating record',
                        message: error.body.message,
                        variant: 'error',
                    }),
                );
                console.log("error", JSON.stringify(this.error));
            });
    }
    
}