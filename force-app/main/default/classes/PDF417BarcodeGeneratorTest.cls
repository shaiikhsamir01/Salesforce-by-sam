@isTest
public class PDF417BarcodeGeneratorTest {
    @isTest
    static void testGetAllSobjectFields() {
        // Test data setup
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Test.startTest();
        List<PDF417BarcodeGenerator.ResponseWrapper> result = PDF417BarcodeGenerator.getAllSobjectFields(acc.Id);
        Test.stopTest();

        // Asserts
        System.assertEquals(true, result.size() > 0);
    }

    @isTest
    static void testGetSelectedFieldValue() {
        // Test data setup
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Test.startTest();
        String fieldValue = PDF417BarcodeGenerator.getSelectedFieldValue('Name', acc.Id);
        Test.stopTest();

        // Asserts
        System.assertEquals(acc.Name, fieldValue);
    }

    @isTest
    static void testSaveTheChunkFile() {
        // Test data setup
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Test.startTest();
        String base64Data = 'SampleBase64Data';
        Id fileId = PDF417BarcodeGenerator.saveTheChunkFile(acc.Id, 'TestFile.pdf', base64Data, 'application/pdf', null, 'TestField', 'BarcodeVersion');
        Test.stopTest();

        // Asserts
        System.assertNotEquals(null, fileId);
    }

    @isTest
    static void testSaveFiles() {
        // Test data setup
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Test.startTest();
        String base64Data = 'SampleBase64Data';
        Id contentDocumentId = PDF417BarcodeGenerator.saveFiles(acc.Id, 'TestFile.pdf', base64Data, 'TestField', 'BarcodeVersion');
        Test.stopTest();

        // Asserts
        System.assertNotEquals(null, contentDocumentId);

        // Clean up (optional)
        delete [SELECT Id FROM ContentDocument WHERE Id = :contentDocumentId];
    }

    @isTest
    static void testGetAttachmentCount() {
        // Test data setup
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Test.startTest();
        Integer attachmentCount = PDF417BarcodeGenerator.getAttachmentCount(acc.Id);
        Test.stopTest();

        // Asserts
        System.assertEquals(0, attachmentCount);
    }

    @isTest
    static void testSendEmailAttachment() {
        // Test data setup
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Test.startTest();
        String base64Data = 'SampleBase64Data';
        Boolean isSuccess = PDF417BarcodeGenerator.sendEmailAttachment('test@example.com', base64Data, acc.Id, 'TestField', 'BarcodeVersion');
        Test.stopTest();

        // Asserts
        System.assertEquals(true, isSuccess);
    }
}