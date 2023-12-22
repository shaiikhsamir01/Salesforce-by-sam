public class KnowledgeController {
	@AuraEnabled(cacheable=true)
    public static List<Knowledge__DataCategorySelection> getDataCategory() {
        return [SELECT DataCategoryGroupName, DataCategoryName, ParentId, Parent.title, Parent.Question__c, Parent.Answer__c FROM Knowledge__DataCategorySelection];
    }
}