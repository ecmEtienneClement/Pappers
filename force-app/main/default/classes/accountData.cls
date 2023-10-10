public with sharing class accountData {
  //Get All Accounts
  @AuraEnabled(cacheable=true)
  public static List<Account> getAccounts() {
    return [
      SELECT
        Name,
        BillingAddress,
        BillingState,
        CreatedDate,
        Effectif_Max__c,
        Effectif_Min__c,
        Siret__c,
        SIREN__c,
        Code_NAF__c,
        ParentId
      FROM Account
      WITH SECURITY_ENFORCED
      LIMIT 40
    ];
  }

  //Get Account Parent By Id
  @AuraEnabled(cacheable=true)
  public static Account getAccountParentById(String parentId) {
    return [
      SELECT
        Name,
        BillingAddress,
        BillingState,
        CreatedDate,
        Effectif_Max__c,
        Effectif_Min__c,
        Siret__c,
        SIREN__c,
        Code_NAF__c,
        ParentId
      FROM Account
      WHERE Id = :parentId
      WITH SECURITY_ENFORCED
      LIMIT 1
    ];
  }

  //Get Accounts Child By ParentId
  @AuraEnabled(cacheable=true)
  public static List<Account> getAccountsChildByParentId(String parentId) {
    return [
      SELECT
        Name,
        BillingAddress,
        BillingState,
        CreatedDate,
        Effectif_Max__c,
        Effectif_Min__c,
        Siret__c,
        SIREN__c,
        Code_NAF__c,
        ParentId
      FROM Account
      WHERE ParentId = :parentId
      WITH SECURITY_ENFORCED
    ];
  }

  //Get Account By Name Search
  @AuraEnabled
  public static List<Account> accountSearch(String paramQuery) {
    return [
      SELECT
        Name,
        BillingAddress,
        BillingState,
        CreatedDate,
        Effectif_Max__c,
        Effectif_Min__c,
        Siret__c,
        SIREN__c,
        Code_NAF__c,
        ParentId
      FROM Account
      WHERE
        Name LIKE :paramQuery
        OR Siret__c LIKE :paramQuery
        OR SIREN__c LIKE :paramQuery
      WITH SECURITY_ENFORCED
      LIMIT 50
    ];
  }

  //Save Update Liste DataTable Child
  @AuraEnabled
  public static Boolean updateFromDataTableChild(Object paramAccountsList) {
    List<Account> accountsList = (List<Account>) JSON.deserialize(
      JSON.serialize(paramAccountsList),
      List<Account>.class
    );
    if (!accountsList.isEmpty()) {
      update accountsList;
      return true;
    }
    return false;
  }
}
