public class FetchArticles {
   @AuraEnabled(cacheable=true)
    public static Map<String, List<Knowledge__DataCategorySelection>> getArticlesMap() {
        Map<String, List<Knowledge__DataCategorySelection>> articlesMap = new Map<String, List<Knowledge__DataCategorySelection>>();
        List<Knowledge__DataCategorySelection> articles = [SELECT DataCategoryGroupName, DataCategoryName, ParentId, Parent.title,
                                                           Parent.UrlName, Parent.Answer__c FROM Knowledge__DataCategorySelection]; 
        
        for (Knowledge__DataCategorySelection article : articles) {
            String keyGroup = article.DataCategoryGroupName;
             String keyCategory = article.DataCategoryName;
            
            if (!articlesMap.containsKey(keyGroup)) {
                articlesMap.put(keyGroup, new List<Knowledge__DataCategorySelection>());
            }
            articlesMap.get(keyGroup).add(article);
            if(!articlesMap.containsKey(keyCategory)){
                articlesMap.put(keyCategory, new List<Knowledge__DataCategorySelection>());
            }
            articlesMap.get(keyCategory).add(article);
        }
        
        return articlesMap;
    }
    
}