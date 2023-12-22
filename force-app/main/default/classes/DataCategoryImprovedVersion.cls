public class DataCategoryImprovedVersion {
    @AuraEnabled
    public static Map<String, List<String>> getAllCategories() {
        List<String> objType = new List<String>{ 'KnowledgeArticleVersion' };
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

        Map<String, List<String>> dataCategoryMap = new Map<String, List<String>>();

        for (DescribeDataCategoryGroupStructureResult singleResult : describeCategoryStructureResult) {
            String key = singleResult.getName();
            List<String> subcategories = new List<String>();

            processCategories(singleResult.getTopCategories(), subcategories, dataCategoryMap, key);

            dataCategoryMap.put(key, subcategories);
        }

        return dataCategoryMap;
    }

    private static void processCategories(DataCategory[] categories, List<String> subcategories, Map<String, List<String>> dataCategoryMap, String parentCategory) {
        if (categories == null || categories.isEmpty()) {
            return;
        }

        for (DataCategory category : categories) {
            String categoryName = category.getName();
            subcategories.add(categoryName);

            processCategories(category.getChildCategories(), subcategories, dataCategoryMap, categoryName);

            // Add the parent category as a key if there are child categories
            if (parentCategory != null) {
                dataCategoryMap.put(parentCategory, subcategories);
            }
        }
    }
}