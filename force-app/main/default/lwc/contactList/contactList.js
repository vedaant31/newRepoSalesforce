import { LightningElement, wire } from 'lwc';
import firstName from '@salesforce/schema/Contact.FirstName';
import lastName from '@salesforce/schema/Contact.LastName';
import Email from '@salesforce/schema/Contact.Email';
import getContacts from '@salesforce/apex/ContactController.getContacts';
import { reduceErrors } from 'c/ldsUtils';
const COLUMNS = [
    { label: 'First Name', fieldName: firstName.fieldApiName, type: 'text' },
    { label: 'Last Name', fieldName: lastName.fieldApiName, type: 'text' },
    { label: 'Email', fieldName: Email.fieldApiName, type: 'email' }
];
export default class ContactList extends LightningElement {
    columns = COLUMNS;
    @wire(getContacts)
    contacts;

    get errors() {
        return (this.contacts.error) ?
            reduceErrors(this.contacts.error) : [];
    }
}