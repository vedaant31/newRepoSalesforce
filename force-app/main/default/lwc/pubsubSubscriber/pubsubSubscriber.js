import { LightningElement } from 'lwc';
import pubsub from 'c/pubsub' ; 
export default class PubsubSubscriber extends LightningElement {

    message;
    boolValue = false;
    connectedCallback(){
        this.register();
    }
    register(){
        window.console.log('event registered ');
        pubsub.register('simplevt', this.handleEvent.bind(this));
    }
    handleEvent(messageFromEvt){
        console.log('messageFromEvt@@@@@@',messageFromEvt);
        window.console.log('event handled ',messageFromEvt);
        //this.message = messageFromEvt ? JSON.stringify(messageFromEvt, null, '\t') : 'no message payload';
        this.message = JSON.stringify(messageFromEvt.message);
        this.boolValue = messageFromEvt.boolValue;
        console.log('boolValue@@@@@@@@',boolValue);
    }
}