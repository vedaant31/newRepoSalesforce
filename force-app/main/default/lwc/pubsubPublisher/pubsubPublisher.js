import { LightningElement } from 'lwc';
import pubsub from 'c/pubsub' ; 
export default class PubsubPublisher extends LightningElement {

    handleClick(){
        window.console.log('Event Firing..... ');
        let message = {
            "message" : 'Hello PubSub',
            boolValue : false
        }
        console.log('message ---->',message);
        pubsub.fire('simplevt', message );
        window.console.log('Event Fired ');
    }
}