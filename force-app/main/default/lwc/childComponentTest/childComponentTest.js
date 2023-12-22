import { LightningElement,api ,track,wire} from 'lwc';
import getArticles from '@salesforce/apex/FetchArticles.getArticlesMap';
export default class ChildComponentTest extends LightningElement {
    @api categoryName = '';
    @track articleData;
    @track articlesMap;
    error;
    displayArticle=false;

    /*connectedCallback() {
        getArticles().then(x => {
            this.articlesMap = x;
            console.log('i am map', x)
        }).catch(error => {
            console.log(error);
        });
    }*/

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
        console.log('i am getting call');
          this.displayArticle=true;
         this.categoryName = clickedValue;
         this.articleData = Array.from(this.articlesMap[this.categoryName]);
         console.log('article list',this.articleData);
    }

}
