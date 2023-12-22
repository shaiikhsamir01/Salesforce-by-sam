public class CategoryInfo{
    @AuraEnabled
    public static Map<String, list<String>> getAllCategories(){
        List<String> objType = new List<String>();
        objType.add('KnowledgeArticleVersion');
        List<DescribeDataCategoryGroupResult> describeCategoryResult = Schema.describeDataCategoryGroups(objType);
        List<DataCategoryGroupSobjectTypePair> pairs = new List<DataCategoryGroupSobjectTypePair>();
        for (DescribeDataCategoryGroupResult singleResult : describeCategoryResult) {
            DataCategoryGroupSobjectTypePair p = new DataCategoryGroupSobjectTypePair();
            p.setSobject(singleResult.getSobject());
            p.setDataCategoryGroupName(singleResult.getName());
            pairs.add(p);
        }
        
        List<DescribeDataCategoryGroupStructureResult> describeCategoryStructureResult =
            Schema.describeDataCategoryGroupStructures(pairs, false);
        
        // Create a map to store DataCategory information
        Map<String, list<String>> dataCategoryMap = new Map<String, list<String>>();
        
        for (DescribeDataCategoryGroupStructureResult singleResult : describeCategoryStructureResult) {
            String key = singleResult.getName(); // Use DataCategoryGroup name as the key
            list<String> subcategories = new list<String>();
            
            DataCategory[] toplevelCategories = singleResult.getTopCategories();
            
            for (DataCategory topCategory : toplevelCategories) {
                String topLevelCategoryName = topCategory.getName();
                
                
                // Get the list of sub-categories in the top-level category
                DataCategory[] childCategories = topCategory.getChildCategories();
                
                
                for (DataCategory subcategory : childCategories) {      
                        subcategories.add(subcategory.getName());
                    String childLevelCategoryName = subcategory.getName();
                    DataCategory[] childofchildCategories = subcategory.getChildCategories();
                    
                    if (childofchildCategories != null && childofchildCategories.size() > 0) {
                        list<String> childofchildCategoryNames = new list<String>();
                        for(DataCategory subofsubcategory : childofchildCategories){
                            childofchildCategoryNames.add(subofsubcategory.getName());
                            String grandLevelCategoryName = subofsubcategory.getName();
                            DataCategory[] grandChildCategories = subofsubcategory.getChildCategories();
                            if(grandChildCategories != null && grandChildCategories.size() > 0){
                                list<String> grandChildCategoryNames = new list<String>();
                                for(DataCategory grandSubcategory : grandChildCategories){
                                    grandChildCategoryNames.add(grandSubcategory.getName());
                                    String lastLevelChildCategoryName=grandSubcategory.getName();
                                    DataCategory[] lastChildCategories = grandSubcategory.getChildCategories();
                                    if(lastChildCategories != null && lastChildCategories.size() > 0){
                                        list<String> lastChildCategoryNames = new list<String>();
                                        for(DataCategory lastSubcategory : lastChildCategories){
                                            lastChildCategoryNames.add(lastSubcategory.getName());
                                        }
                                        dataCategoryMap.put(lastLevelChildCategoryName,lastChildCategoryNames);
                                    }
                                }
                                dataCategoryMap.put(grandLevelCategoryName,grandChildCategoryNames); 
                            }
                        }
                        dataCategoryMap.put(childLevelCategoryName,childofchildCategoryNames);
                    }
                    
                }
            }
            dataCategoryMap.put(key, subcategories);
        }
        
        return dataCategoryMap;
    }
}