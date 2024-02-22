@IsTest
public class PappersMock implements HttpCalloutMock {
  public static HttpResponse respond(HttpRequest req) {
    HttpResponse res = new HttpResponse();

    res.setHeader('content-Type', 'application/json;charset=utf-8');
    res.setBody(
      '{"siren":"652014051","siren_formate":"652 014 051","diffusable":true,"nom_entreprise":"CARREFOUR","personne_morale":true,"denomination":"CARREFOUR","sigle":null,"nom":null,"prenom":null,"sexe":null,"siege":{"siret":"65201405100732","siret_formate":"652 014 051 00732","diffusion_partielle":false,"nic":"00732","numero_voie":93,"indice_repetition":null,"type_voie":"AV","libelle_voie":"DE PARIS","complement_adresse":null,"adresse_ligne_1":"93 AV DE PARIS","adresse_ligne_2":null,"code_postal":"91300","ville":"MASSY","pays":"France","code_pays":"FR","latitude":48.723522,"longitude":2.265398,"code_naf":"64.20Z","libelle_code_naf":"Activités des sociétés holding","date_de_creation":"2019-01-01","etablissement_employeur":false,"effectif":"0 salarié","effectif_min":0,"effectif_max":0,"tranche_effectif":"03","annee_effectif":2020,"etablissement_cesse":false,"date_cessation":null,"domiciliation":null,"siege":true,"enseigne":"ASSURANCES CARREFOUR - SERVICES FIN","nom_commercial":"ASSU CARREFOUR SERV FINANCIERS CARREFOUR","predecesseurs":[{"siret":"65201405100724","date":"2019-01-01","transfert_siege":false,"continuite_economique":true}]}'
    );
    res.setStatusCode(200);

    return res;
  }
}
