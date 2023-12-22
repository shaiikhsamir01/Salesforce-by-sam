import { LightningElement, api, wire, track } from 'lwc';
import getAllCategories from '@salesforce/apex/CategoryInfo.getAllCategories';
import getDataCategoryGroup from '@salesforce/apex/DataCategoryController.fetchDataCategoriesGroup';
export default class KnowledgeCategoryTiles extends LightningElement {
  @track clickedKey
  categoryGroup=[];
  @track allCategories;
  error;
  filterCategory;
  @wire(getDataCategoryGroup)
  getGroups(result) {
    if (result.data) {
       let protectedArray=Array.from(result.data);
       for(const x of protectedArray){
         this.categoryGroup.push(x);
       }
      console.log('i am catgeorygroup',this.categoryGroup);
    } else {
      this.error = result.error;
    }
  }
  connectedCallback(){
    getAllCategories().then(x=>{
      this.allCategories=x;
      console.log('i am keys',Object.keys(this.allCategories));
      console.log('i am values',Object.values(this.allCategories));
      console.log(x);
    }).catch(error=>{
      console.log(error);
    })
  }

  handleClick(event) {
    try {

      this.clickedKey = event.currentTarget.dataset.key;
      console.log(this.clickedKey);
      let proxyArray=this.allCategories[this.clickedKey];
      this.filterCategory=Array.from(proxyArray);
      //this.categoryGroup=this.filterCategory;
     /* this.filterCategory= normalArray.map(element => ({ [element]: element }));
      console.log('i am c',this.filterCategory);*/
      this.template.querySelector("c-show-articles").diplayCategory(this.clickedKey);
    } catch (error) {
      console.log(error);
    }

  }

}