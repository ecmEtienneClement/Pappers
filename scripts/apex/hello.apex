String api_token = Label.ApiTokenPappers;
String endpoint =
  'https://api.pappers.fr/v1/entreprise?api_token=' +
  api_token +
  '&siren=' +
  '65201405100724';
HttpRequest req = new HttpRequest();
HttpResponse res = new HttpResponse();
Http ht = new Http();
req.setHeader('Content-Type', 'application/json; charset=utf-8');

req.setEndpoint(endpoint);
req.setMethod('GET');

res = Ht.send(req);
System.debug('response of request ***** : ' + res.getBody());
