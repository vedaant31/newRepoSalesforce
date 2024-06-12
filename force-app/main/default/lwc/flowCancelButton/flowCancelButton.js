import { LightningElement, api } from 'lwc';
import { FlowNavigationNextEvent } from 'lightning/flowSupport';
import { NavigationMixin } from 'lightning/navigation';

export default class FlowCancelButton extends NavigationMixin(LightningElement) {
    @api recordId;

    goPrev() {
        window.history.back();
    }

    goNext() {
        console.log('Hi');
        const eee = new FlowNavigationNextEvent();
        this.dispatchEvent(eee);
        if (this.recordId) {
            this.navigateToRecord();
        }
    }

    navigateToRecord() {

        console.log('netered');
        console.log(this.recordId);
        if (this.recordId) {
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId:'001IS000005c51xYAA',
                    objectApiName: 'Account', // replace with your object's API name
                    actionName: 'view'
                }
            });
        } else {
            console.error('Record ID is not available.');
        }
    }

    connectedCallback() {
       
    }
}