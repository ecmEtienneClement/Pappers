@IsTest
public with sharing class AccountApiPappersTest {
  @TestSetup
  private static void initTest() {
    //Create accounts
    List<Account> accountsList = new List<Account>();
    for (Integer i = 0; i < 5; i++) {
      Account newAccount = new Account();
      newAccount.Name = 'Name' + i;
      newAccount.Siret__c = 'siret' + i;
      accountsList.add(newAccount);
    }
    //Save accounts
    insert accountsList;
  }

  @isTest
  public static void lanchBatchTest() {
    Id id = AccountApiPappers.launchBatch('siret1');
    System.Assert.isInstanceOfType(
      id,
      Id.class,
      'Une instance d\'id est attendu.'
    );
  }

  @isTest
  public static void getAccountBySiretTest() {
    //Test
    Account accountTest = AccountApiPappers.getAccountBySiret('siret1');
    System.assertEquals(accountTest.Name, 'Name1', 'Le Name attendu est Name1');
    System.assertEquals(
      accountTest.Siret__c,
      'siret1',
      'Le Siret attendu est siret1'
    );
  }
  @isTest
  public static void getAccountBySiretTest02() {
    //Test
    Account accountTest = AccountApiPappers.getAccountBySiret('siret3');
    System.assertEquals(accountTest.Name, 'Name3', 'Le Name attendu est Name3');
    System.assertEquals(
      accountTest.Siret__c,
      'siret3',
      'Le Siret attendu est siret3'
    );
  }
  @isTest
  public static void getAccountBySiretTestExcep() {
    //Test
    try {
      Account accountTest = AccountApiPappers.getAccountBySiret('siret');
    } catch (Exception ex) {
      System.Assert.isInstanceOfType(
        ex,
        Exception.class,
        'Une exception est attendu...'
      );
    }
  }
}
