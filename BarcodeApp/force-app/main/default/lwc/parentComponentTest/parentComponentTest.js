import { LightningElement, track, wire } from 'lwc';
import sampleMethod from '@salesforce/apex/SampleClassTest.sampleMethod';
import getAllCategories from '@salesforce/apex/CategoryInfo.getAllCategories';
import getDataCategoryGroup from '@salesforce/apex/DataCategoryController.fetchDataCategoriesGroup';
export default class ParentComponentTest extends LightningElement {
  @track copyOfArticlesMap;
  @track parentValue = '';
  storeResult;
  categoryGroup = [];
  @track allCategories
  filterCategory = [];
  nocategoryFound = false;
  error;

  @wire(getDataCategoryGroup)
  getGroups(result) {
    if (result.data) {
      this.categoryGroup = result.data;
    } else {
      this.error = result.error;
    }
  }


  //Taking onto next step
  /*@wire(getDataCategoryGroup)
  getGroups(result) {
    if (result.data) {
      this.categoryGroup = result.data.map((item) => {
        const key = item;
        const length = this.copyOfArticlesMap[key] ? this.copyOfArticlesMap[key].length : 0;
        return { key, length };
      });
      console.log(this.categoryGroup);
    } else {
      this.error = result.error;
    }
  }*/


  connectedCallback() {
    //this.copyOfArticlesMap = this.template.querySelector("c-show-articles").articlesMap;
    //console.log('data is ready',this.copyOfArticlesMap);
    getAllCategories().then(x => {
      this.allCategories = x;
    }).catch(error => {
      console.log(error);
    })
  }

  handleClick(event) {
    try {

      this.clickedKey = event.currentTarget.dataset.key;
      console.log(this.clickedKey);
      console.log(this.allCategories);
      if (this.allCategories.hasOwnProperty(this.clickedKey)) {
        this.filterCategory = this.allCategories[this.clickedKey];
        if (this.filterCategory.length === 0) {
          this.nocategoryFound = true;
        }
        this.categoryGroup = this.filterCategory;
      } else {
        this.nocategoryFound = true;
      }
      this.template.querySelector("c-show-articles").diplayCategory(this.clickedKey);
    } catch (error) {
      console.log(error);
    }

  }

  refreshPage(){
    window.location.reload();
  }


}