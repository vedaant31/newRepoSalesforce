import { LightningElement ,api} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import {FlowNavigationNextEvent} from'lightning/flowSupport';
export default class ToastForOpp extends LightningElement {
    @api variant;
    @api toastMessage;
    @api title;
    @api mode;
    connectedCallback()
    {
        this.HandleToas();
        // this.HandleClose();
    }

    HandleToas(){
        const event = new ShowToastEvent({
            title:this.title,
            message: this.toastMessage,
                variant:this.variant,
                mode: this.mode
        });
        this.dispatchEvent(event);
    
        }
        HandleClose()
        {
            const navigateNextEvent=new FlowNavigationNextEvent(); 
            this.dispatchEvent(navigateNextEvent);
        }
}