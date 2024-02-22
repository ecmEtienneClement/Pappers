@IsTest
public class PappersTest {
  @IsTest
  public static void getRequestData() {
    Test.setMock(HttpCalloutMock.class, new PappersMock());
    //  siren = '652014051';
    HttpResponse res = Pappers.getRequestData('777');
    System.assertEquals(201, res.getStatusCode(), 'Le code attendu est 200');
    System.assertEquals(
      res.getHeaderKeys('content-Type'),
      'application/json;charset=utf-8',
      'Le code attendu est 200'
    );
  }
}
