import { LightningElement ,api, wire} from 'lwc';
import getContacts from '@salesforce/apex/contactControlller.getContacts';
export default class WireClass extends LightningElement {

    @api recordId;
    @wire (getContacts,{accId :'$recordId'}) contacts;


}