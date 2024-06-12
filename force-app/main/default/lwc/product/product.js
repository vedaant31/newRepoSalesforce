import { LightningElement, track, wire } from 'lwc';
import getProducts from '@salesforce/apex/productController.getProducts';
import saveProductData from '@salesforce/apex/productStorage.saveProductData';
import sendData from '@salesforce/apex/productGetter.sendData';
import saveArray from '@salesforce/apex/SaveArrayController.saveArray';


export default class Product extends LightningElement {
    @track products = [];
    @track recData=[];
    @track totalQuantity = 0;
    @track productMap = {};
    productPrice = {};
    @track productPrices;
    @track limitedMonths = [];
    @track remainingMonths = [];

    netsum = 0;
    currMonth;
    monthsArray = [];
    calculateTotal = 0;
    months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    alreadyRec=false;
    
    
    constructor() {
        super();
        const today = new Date();
        let month = today.getMonth() + 1;
        this.currMonth = month;
        for (let index = 1; index < this.currMonth; index++) {
            this.monthsArray.push(index);
        }
        this.limitedMonths = this.months.slice(0, this.currMonth - 1);
        this.remainingMonths = this.months.slice(this.currMonth - 1);
        // console.log(JSON.stringify(this.monthsQty));


    }
    @wire(getProducts)
    wiredProducts({ error, data }) {
        console.log('hi');
        if (data) {
            this.products = data;
        } 
    }
    @wire(sendData)
    wired({ error, data }) {
        if (data) {
            this.recData = data;
            // this.alreadyRec=true;
        } 
    }
    
    // renderedCallback()
    // {

    //     if(this.alreadyRec==true){
    //     this.recData.forEach(it => {
            
    //         const inputs = this.template.querySelectorAll(`lightning-input[data-product-id="${it.Id}"].ved`);
    //     inputs.forEach(input => {
    //         input.value = it.TotalYearPrice__c;
    //     });
        
    //     //     const qtyInputs1 =  this.template.querySelectorAll(`lightning-input[data-product-id="${it.Id}"].Jan`);
    //     //     qtyInputs1.forEach(chng => {
    //     //     chng.value = it.JanQty__c;
    //     // });
    //     //     const qtyInputs2 =  this.template.querySelectorAll(`lightning-input[data-product-id="${it.Id}"].Feb`);
    //     //     qtyInputs2.forEach(chng => {
    //     //     chng.value = it.FebQty__c;
    //     // });
    //     //     const qtyInputs3 =  this.template.querySelectorAll(`lightning-input[data-product-id="${it.Id}"].Mar`);
    //     //     qtyInputs3.forEach(chng => {
    //     //     chng.value = it.MarQty__c;
    //     // });
    //     //     const qtyInputs4 =  this.template.querySelectorAll(`lightning-input[data-product-id="${it.Id}"].Apr`);
    //     //     qtyInputs4.forEach(chng => {
    //     //     chng.value = it.AprQty__c;
    //     // });
    //     //     const qtyInputs5 =  this.template.querySelectorAll(`lightning-input[data-product-id="${it.Id}"].May`);
    //     //     qtyInputs5.forEach(chng => {
    //     //     chng.value = it.MayQty__c;
    //     // });
    //     //     const qtyInputs6 =  this.template.querySelectorAll(`lightning-input[data-product-id="${it.Id}"].Jun`);
    //     //     qtyInputs6.forEach(chng => {
    //     //     chng.value = it.JunQty__c;
    //     // });
    //     //     const qtyInputs7 =  this.template.querySelectorAll(`lightning-input[data-product-id="${it.Id}"].Jul`);
    //     //     qtyInputs7.forEach(chng => {
    //     //     chng.value = it.JulQty__c;
    //     // });
    //     //     const qtyInputs8 =  this.template.querySelectorAll(`lightning-input[data-product-id="${it.Id}"].Aug`);
    //     //     qtyInputs8.forEach(chng => {
    //     //     chng.value = it.AugQty__c;
    //     // });
    //     //     const qtyInputs9 =  this.template.querySelectorAll(`lightning-input[data-product-id="${it.Id}"].Sep`);
    //     //     qtyInputs9.forEach(chng => {
    //     //     chng.value = it.SepQty__c;
    //     // });
    //     //     const qtyInputs10 =  this.template.querySelectorAll(`lightning-input[data-product-id="${it.Id}"].Oct`);
    //     //     qtyInputs10.forEach(chng => {
    //     //     chng.value = it.OctQty__c;
    //     // });
    //     //     const qtyInputs11 =  this.template.querySelectorAll(`lightning-input[data-product-id="${it.Id}"].Nov`);
    //     //     qtyInputs11.forEach(chng => {
    //     //     chng.value = it.NovQty__c;
    //     // });
    //     //     const qtyInputs12 =  this.template.querySelectorAll(`lightning-input[data-product-id="${it.Id}"].Dec`);
    //     //     qtyInputs12.forEach(chng => {
    //     //     chng.value = it.DecQty__c;
    //     // });

            
    //     });

    // }
    

   
        
    // }


    saveRecord(event) {

       const monthsQty = new Array(12).fill(0);


        const prodId = event.target.dataset.productId;
        const pricee = event.target.dataset.price;
        const currMonth=event.target.dataset.month;
        console.log('curr',currMonth);
        const elements = this.template.querySelectorAll(`lightning-input[data-product-id="${prodId}"].monthes`);
        // console.log('months-->',this.months)
        let qty = 0;
        elements.forEach(element => {
            const value = element.value.trim();
            if (value) {
                qty += parseInt(value, 10);
            } 
        });
        this.calculateTotal = qty * pricee;
        const inputs = this.template.querySelectorAll(`lightning-input[data-product-id="${prodId}"].ved`);
        inputs.forEach(input => {
            input.value = this.calculateTotal;
        });
        this.months.forEach((mnth,index) => {
            console.log('yahan fatta');
            console.log('month',mnth);
            console.log('prod id',prodId);
            const monthValues = this.template.querySelectorAll(`lightning-input[data-month="${mnth}"][data-product-id="${prodId}"].monthes`);
            console.log('valuess for arr',monthValues);
            monthValues.forEach(val => {
                const value = val.value.trim();
                console.log('value is ',value);
                if (value) {
                    monthsQty[index]=parseInt(value,10);
                    console.log('type of value is',typeof value);

                    console.log(` Index is ${index} and value for ${mnth} is ${value}`);
                } 
            });
        });
        console.log('array',JSON.stringify(monthsQty));

        const productData = {
            Id: prodId,
            TotalQty__c: qty,
            TotalYearPrice__c: this.calculateTotal,
            JanQty__c:monthsQty[0],
            FebQty__c:monthsQty[1],
            MarQty__c:monthsQty[2],
            AprQty__c:monthsQty[3],
            MayQty__c:monthsQty[4],
            JunQty__c:monthsQty[5],
            JulQty__c:monthsQty[6],
            AugQty__c:monthsQty[7],
            SepQty__c:monthsQty[8],
            OctQty__c:monthsQty[9],
            NovQty__c:monthsQty[10],
            DecQty__c:monthsQty[11]
           
        };

        saveProductData({ products: [productData] })
            .then(() => {
                console.log('Product data saved successfully');
            })
            .catch(error => {
                console.error('Error saving product data: ', error);
            });

          
    }
    calculateNetTotal() {
        let TC = 0;
        const sumValues = this.template.querySelectorAll(`.ved`);
        sumValues.forEach(element => {
            const value = element.value.trim();

            if (value) {
                TC += parseInt(value, 10);
            }
        });
        const chng = this.template.querySelector(`.totalSum`);
        chng.value = TC;
    }
    handleQuantityChange(event) {
        const qnt = parseInt(event.target.value, 10);
        if (isNaN(qnt)) {
            return;
        }
    }
}