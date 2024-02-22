public with sharing class AccountApiPappers {
  //
  @AuraEnabled(cacheable=true)
  public static Id launchBatch(String inputSiret) {
    return Database.executeBatch(new AccountBatchPappers(inputSiret));
  }

  @AuraEnabled(cacheable=true)  
  public static Account getAccountBySiret(String inputSiret) {
    try {
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
        WHERE Siret__c = :inputSiret
        WITH SECURITY_ENFORCED
        LIMIT 1
      ];
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }
}
