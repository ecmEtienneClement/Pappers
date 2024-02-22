public with sharing class AccountBatchPappers implements Database.Batchable<sObject> {
  private String siret;
  public AccountBatchPappers(String inputSiret) {
    this.siret = inputSiret;
  }

  //
  public Database.QueryLocator start(Database.BatchableContext ctx) {
    System.debug('********start********');
    // String apiToken = Label.ApiTokenPappers;
    // String apiUri = Label.URIPappersEntreprise;
    // String apiEndpoint = apiUri + '?api_token=' + apiToken + '&siren=' + siret;
    // //
    // Http http = new Http();
    // HttpRequest req = new HttpRequest();
    // req.setHeader('Content-Type', 'application/json; charset=utf-8');
    // req.setEndpoint(apiEndpoint);
    // req.setMethod('GET');
    // System.debug('aaa' + apiUri);

    return Database.getQueryLocator(
      [
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
        WHERE Siret__c = :siret
        WITH SECURITY_ENFORCED
        LIMIT 1
      ]
    );
  }
  //
  public void execute(Database.BatchableContext ctx, List<Account> scopeList) {
    //
    System.debug('********execute********');
    System.debug(scopeList);

    // insert scopeList;
  }
  //
  public void finish(Database.BatchableContext ctx) {
    //
    System.debug('********finish********');
  }
}
