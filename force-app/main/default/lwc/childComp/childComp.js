import { LightningElement ,api} from 'lwc';


export default class ChildComp extends LightningElement {
    @api tablefields=[];
    @api tablecolumns=[];
    @api checkcancel=false;
    
 myfn(){
    console.log('my fields are '+ tablefields);
    console.log('my columns are ' + tablecolumns);
 }   
 //customevent(fn,detail:)

   
  


}