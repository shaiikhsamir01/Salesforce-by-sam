import { LightningElement, api, track, wire } from 'lwc';
import getArticles from '@salesforce/apex/FetchArticles.getArticlesMap';
export default class ShowArticles extends LightningElement {
    @api categoryName = '';
    @track articleData;
    @api articlesMap;
    error;
    displayArticle=false;
    dynamicText= 'Select category to see article here';

    @wire(getArticles)
    wiredArticles({ data, error }) {
        if (data) {
            this.articlesMap = data;
        } else if (error) {
            console.error('i am error', error);
        }
    }

    
    @api
    diplayCategory(clickedValue) {
          this.displayArticle=true;
         this.categoryName = clickedValue;
         if (this.articlesMap.hasOwnProperty(this.categoryName)) {
            this.articleData = Array.from(this.articlesMap[this.categoryName]);
         }
         else{
            this.dynamicText='Selected category has no article';
            this.displayArticle=false;
         }
    }
   

}