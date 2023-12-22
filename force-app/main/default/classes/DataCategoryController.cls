public with sharing class DataCategoryController {
    @AuraEnabled(cacheable=true)
    public static List<String> fetchDataCategoriesGroup() {
        List<String> result = new List<String>();
        List<String> objType = new List<String>{'KnowledgeArticleVersion'};
      List<DescribeDataCategoryGroupResult> describeCategoryResult=Schema.describeDataCategoryGroups(objType);

        if (!describeCategoryResult.isEmpty()) {
            for(DescribeDataCategoryGroupResult singleGroup :describeCategoryResult){
               result.add(singleGroup.getName()); 
                system.debug(singleGroup);
            }
 
        }
        return result;
    }
}