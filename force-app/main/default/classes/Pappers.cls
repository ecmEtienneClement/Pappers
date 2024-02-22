/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 09-17-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 **/
public with sharing class Pappers {
  public Pappers() {
  }

  public static HttpResponse getRequestData(String siren) {
    String api_token = Label.ApiTokenPappers;
    String endpoint =
      'https://api.pappers.fr/v1/entreprise?api_token=' +
      api_token +
      '&siren=' +
      siren;
    HttpRequest req = new HttpRequest();
    HttpResponse res = new HttpResponse();
    Http ht = new Http();
    req.setHeader('Content-Type', 'application/json; charset=utf-8');

    req.setEndpoint(endpoint);
    req.setMethod('GET');

    res = Ht.send(req);
    System.debug('response of request ***** : ' + res.getBody());
    //System.debug(' getStatusCode() ***** : '+res.getStatusCode());
    List<Account> listEtablissement = new List<Account>();

    if (res.getStatusCode() == 201) {
      JSON2ApexClass_Salesforcecody responseObject = (JSON2ApexClass_Salesforcecody) json.deserialize(
        res.getBody(),
        JSON2ApexClass_Salesforcecody.class
      );
      // IMappingObject mapper = new MappingObjectV2();
      //  mapper.mapper(responseObject);
      Account accParent = MappingObject.mapDataAccountParent(responseObject);
      if (accParent != null) {
        upsert accParent;
        if (accParent.Id != null) {
          // Ajout des etablissements
          if (responseObject.etablissements.size() > 0) {
            for (cls_etablissements s : responseObject.etablissements) {
              listEtablissement.add(
                MappingObject.mapEtablissements(s, accParent)
              );
            }
            if (listEtablissement.size() > 0) {
              upsert listEtablissement;
            }
          }
          // Ajout des representants
          if (responseObject.representants.size() > 0) {
            MappingObject.mapRepresentants(
              responseObject.representants,
              accParent
            );
          }
          // Ajout Beneficiaires
          if (responseObject.beneficiaires_effectifs.size() > 0) {
            MappingObject.mappingBeneficiaires(
              responseObject.beneficiaires_effectifs,
              accParent
            );
          }
          // Ajout Finances
          if (responseObject.finances.size() > 0) {
            MappingObject.mappingFinances(responseObject.finances, accParent);
          }
          //Ajout Annonces Bodacc
          if (responseObject.publications_bodacc.size() > 0) {
            MappingObject.mappingPublicationBodacc(
              responseObject.publications_bodacc,
              accParent
            );
          }
          //Ajout Depots actes
          if (responseObject.depots_actes.size() > 0) {
            MappingObject.mappingDepotsActes(
              responseObject.depots_actes,
              accParent
            );
          }
          // Ajout Compte sociaux
          if (responseObject.comptes.size() > 0) {
            MappingObject.mappingCompte(responseObject.comptes, accParent);
          }
        }
      }
    }
    return res;
  }

  public class JSON2ApexClass_Salesforcecody {
    public String siren; //443061841
    public String siren_formate; //443 061 841
    public String nom_entreprise; //GOOGLE FRANCE
    public boolean personne_morale;
    public String denomination; //GOOGLE FRANCE
    public String nom;
    public String prenom;
    public String sexe;
    public String statut_rne;
    public String derniere_mise_a_jour_rne;
    public String date_immatriculation_rne;
    public String date_immatriculation;
    public String date_radiation_rne;
    public String date_radiation;
    public String code_naf; //70.10Z
    public String libelle_code_naf; //Activités des sièges sociaux
    public String domaine_activite; //Activités des sièges sociaux ; conseil de gestion
    public cls_conventions_collectives[] conventions_collectives;
    public String date_creation; //2002-05-16
    public String date_creation_formate; //16/05/2002
    public boolean entreprise_cessee;
    public String date_cessation; //2002-05-16
    public boolean entreprise_employeuse;
    public boolean societe_a_mission;
    public String categorie_juridique; //5499
    public String forme_juridique; //Société à responsabilité limitée (SARL)
    public String forme_exercice; //Commerciale
    public String effectif; //Entre 500 et 999 salariés
    public Integer effectif_min; //500
    public Integer effectif_max; //999
    public String tranche_effectif; //41
    public String annee_effectif; //2017
    public String capital; //464884017
    public String statut_rcs; //Inscrit
    public cls_siege siege;
    public boolean diffusable;
    public String sigle;
    public String objet_social; //Fourniture de services et/ou conseils relatifs aux logiciels au réseau internet aux réseaux télématiques ou en ligne notamment L'intermediation en matière de vente de publicité en ligne la promotion sous toutes ses formes de la publicité en ligne la promotion directe de produits et services et la mise en oeuvre de centres de traitement de l'information
    public String capital_formate; //464 884 017,00 €
    public String devise_capital; //Euros
    public String numero_rcs; //464884017 R.C.S. Paris
    public String date_cloture_exercice;
    public String date_cloture_exercice_exceptionnelle;
    public String date_cloture_exercice_exceptionnelle_formate;
    public String prochaine_date_cloture_exercice;
    public String prochaine_date_cloture_exercice_formate;
    public boolean economie_sociale_solidaire;
    public String dernier_traitement; //2020-07-09
    public String derniere_mise_a_jour_sirene; //2020-08-13
    public String derniere_mise_a_jour_rcs; //2020-06-25
    public String greffe; //Paris
    public String code_greffe; //7501
    public String date_debut_activite; //2002-08-14
    public String date_debut_premiere_activite;
    public String numero_tva_intracommunautaire; //FR64443061841
    public boolean validite_tva_intracommunautaire;
    public boolean associe_unique;
    public cls_etablissements[] etablissements;
    public cls_finances[] finances;
    public cls_representants[] representants;
    public cls_beneficiaires_effectifs[] beneficiaires_effectifs;
    public cls_depots_actes[] depots_actes;
    public cls_comptes[] comptes;
    public cls_publications_bodacc[] publications_bodacc;
    public cls_procedures_collectives[] procedures_collectives;
    public boolean procedure_collective_existe;
    public boolean procedure_collective_en_cours;
    public cls_derniers_statuts derniers_statuts;
    public cls_extrait_immatriculation extrait_immatriculation;
    public cls_rnm rnm;
    public cls_marques[] marques;
    public cls_association association;
  }

  public class cls_conventions_collectives {
    public String nom; //Convention collective nationale applicable au personnel des bureaux d'études techniques des cabinets d'ingénieurs-conseils et des sociétés de conseils(BET SYNTEC)
    public Integer idcc; //1486
    public boolean confirmee;
  }
  public class cls_siege {
    public String siret; //44306184100047
    public String siret_formate; //443 061 841 00047
    public boolean diffusion_partielle;
    public String nic; //00047
    public String code_postal; //75009
    public String ville; //PARIS 9
    public String pays; //France
    public String code_pays; //FR
    public Double latitude; //48.876947
    public Double longitude; //2.329981
    public boolean etablissement_cesse;
    public boolean siege;
    public boolean etablissement_employeur;
    public String effectif; //Entre 500 et 999 salariés
    public Integer effectif_min; //500
    public Integer effectif_max; //999
    public String tranche_effectif; //41
    public String annee_effectif; //2017
    public String code_naf; //70.10Z
    public String libelle_code_naf; //Activités des sièges sociaux
    public String date_de_creation; //2011-05-12T22:00:00.000Z
    public Integer numero_voie; //8
    public String indice_repetition;
    public String type_voie; //RUE
    public String libelle_voie; //DE LONDRES
    public String complement_adresse;
    public String adresse_ligne_1; //8 RUE DE LONDRES
    public String adresse_ligne_2;
    public String date_cessation; //2014-05-12
    public String enseigne; //FROOGLE
    public String nom_commercial; //Froogle
    public cls_domiciliation domiciliation;
    //public cls_predecesseurs[] predecesseurs;
    //public cls_successeurs[] successeurs;
  }

  public class cls_domiciliation {
    public String nom; //WORK & SHARE
    public String siren; //828053546
  }
  public class cls_predecesseurs {
    public String siret; //44306184100047
    public String datePredecesseurs; //1993-20-02
    public boolean transfert_siege;
    public boolean continuite_economique;
  }
  public class cls_successeurs {
    public String siret; //44306184100047
    public String dateSuccesseur; //1993-20-02
    public boolean transfert_siege;
    public boolean continuite_economique;
  }

  public class cls_etablissements {
    public String siret; //44306184100047
    public String siret_formate; //443 061 841 00047
    public boolean diffusion_partielle;
    public String nic; //00047
    public String code_postal; //75009
    public String ville; //PARIS 9
    public String pays; //France
    public String code_pays; //FR
    public Double latitude; //48.876947
    public Double longitude; //2.329981
    public boolean etablissement_cesse;
    public boolean siege;
    public boolean etablissement_employeur;
    public String effectif; //Entre 500 et 999 salariés
    public Integer effectif_min; //500
    public Integer effectif_max; //999
    public String tranche_effectif; //41
    public String annee_effectif; //2017
    public String code_naf; //70.10Z
    public String libelle_code_naf; //Activités des sièges sociaux
    public String date_de_creation; //2011-05-12T22:00:00.000Z
    public Integer numero_voie; //8
    public String indice_repetition;
    public String type_voie; //RUE
    public String libelle_voie; //DE LONDRES
    public String complement_adresse;
    public String adresse_ligne_1; //8 RUE DE LONDRES
    public String adresse_ligne_2;
    public String date_cessation; //2014-05-12
    public String enseigne; //FROOGLE
    public String nom_commercial; //Froogle
    public cls_domiciliation domiciliation;
    //public cls_predecesseurs[] predecesseurs;
    //public cls_successeurs[] successeurs;
  }
  public class cls_finances {
    public String annee; //2018
    public String date_de_cloture_exercice; //2018-12-31
    public Integer duree_exercice; //12
    public Decimal chiffre_affaires; //411016329
    public Decimal resultat; //29327087
    public Integer effectif; //723
    public Decimal marge_brute; //0
    public Decimal excedent_brut_exploitation; //0
    public Decimal resultat_exploitation; //0
    public Decimal taux_croissance_chiffre_affaires; //0
    public Decimal taux_marge_brute; //0
    public Decimal taux_marge_EBITDA; //0
    public Decimal taux_marge_operationnelle; //0
    public Decimal BFR; //0
    public Decimal BFR_exploitation; //0
    public Decimal BFR_hors_exploitation; //0
    public Decimal BFR_jours_CA; //0
    public Decimal BFR_exploitation_jours_CA; //0
    public Decimal BFR_hors_exploitation_jours_CA; //0
    public Decimal delai_paiement_clients_jours; //0
    public Decimal delai_paiement_fournisseurs_jours; //0
    public Decimal ratio_stock_CA_jours; //0
    public Decimal capacite_autofinancement; //0
    public Decimal capacite_autofinancement_CA; //0
    public Decimal fonds_roulement_net_global; //0
    public Decimal couverture_BFR; //0
    public Decimal tresorerie; //0
    public Decimal dettes_financieres; //0
    public Decimal capacite_remboursement; //0
    public Decimal ratio_endettement; //0
    public Decimal autonomie_financiere; //0
    public Decimal taux_levier; //0
    public Decimal etat_dettes_1_an_au_plus; //0
    public Decimal liquidite_generale; //0
    public Decimal couverture_dettes; //0
    public Decimal marge_nette; //0
    public Decimal rentabilite_fonds_propres; //0
    public Decimal rentabilite_economique; //0
    public Decimal valeur_ajoutee; //0
    public Decimal valeur_ajoutee_CA; //0
    public Decimal salaires_charges_sociales; //0
    public Decimal salaires_CA; //0
    public Decimal impots_taxes; //0
  }
  public class cls_representants {
    public String qualite; //Gérant
    public boolean personne_morale;
    public String date_prise_de_poste; //2017-08-03
    public String sexe; //M
    public String nom; //Yi
    public String prenom; //Kenneth H.
    public String prenom_usuel; //Kenneth
    public String nom_complet; //Kenneth H. Yi
    public String date_de_naissance; //1970-01-06
    public String date_de_naissance_formate; //06/01/1970
    public Integer age; //50
    public String nationalite; //Américaine (Etats Unis)
    public String code_nationalite; //US
    public String ville_de_naissance; //Séoul
    public String pays_de_naissance; //COREE DU SUD
    public String code_pays_de_naissance; //KR
    public String adresse_ligne_1; //1600 Amphitheatre Parkway Mountain View CA 94043
    public String adresse_ligne_2;
    public String adresse_ligne_3;
    public String code_postal;
    public String ville;
    public String pays; //Etats-Unis
    public String code_pays; //US
    public String siren;
    public String forme_juridique;
  }
  public class cls_beneficiaires_effectifs {
    public String date_greffe; //2021-01-06
    public String type; //BE_SOC
    public String nom; //McCourt JR
    //public cls_nom_usage nom_usage;
    public String prenom; //Frank
    public String pseudonyme;
    public String date_de_naissance_formatee; //08/1953
    public String date_de_naissance_complete_formatee; //14/08/1953
    public String nationalite; //Américaine (Etats Unis)
    public String code_nationalite; //US
    public String ville_de_naissance; //Massachusetts
    public String pays_de_naissance; //ETATS-UNIS D'AMERIQUE
    public String code_pays_de_naissance; //US
    public String adresse_ligne_1;
    public String adresse_ligne_2; //888 Seventh Avenue 43rd Floor New York (Etat de New York)
    public String adresse_ligne_3;
    public String code_postal;
    public String ville;
    public String pays; //ETATS-UNIS D'AMERIQUE
    public String code_pays; //US
    public Decimal pourcentage_parts; //0
    public Decimal pourcentage_parts_directes; //0
    public Decimal pourcentage_parts_indirectes; //0
    public Decimal pourcentage_parts_vocation_titulaire; //0
    public String details_parts_directes;
    public String details_parts_indirectes;
    public cls_details_parts_vocation_titulaire details_parts_vocation_titulaire;
    public Decimal pourcentage_votes; //0
    public Decimal pourcentage_votes_directs; //0
    public Decimal pourcentage_votes_indirect; //0
    public cls_details_votes_directs details_votes_directs;
    public cls_details_votes_indirects details_votes_indirects;
    public cls_details_societe_de_gestion details_societe_de_gestion;
    public boolean detention_pouvoir_decision_ag;
    public boolean detention_pouvoir_nom_membre_conseil_administration;
    public boolean detention_autres_moyens_controle;
    public boolean beneficiaire_representant_legal;
    public boolean representant_legal_placement_sans_gestion_delegation;
  }

  class cls_details_parts_directes {
    public Decimal pourcentage_pleine_propriete; //0
    public Decimal pourcentage_nue_propriete; //0
  }
  class cls_details_parts_indirectes {
    public Decimal pourcentage_en_indivision; //0
    public Decimal pourcentage_en_personne_morale; //0
    public cls_details_en_indivision details_en_indivision;
    public cls_details_en_personne_morale details_en_personne_morale;
  }
  class cls_details_en_indivision {
    public Decimal pourcentage_pleine_propriete; //0
    public Decimal pourcentage_nue_propriete; //0
    public Decimal pourcentage_usufruit; //0
  }
  class cls_details_en_personne_morale {
    public Decimal pourcentage_pleine_propriete; //0
    public Decimal pourcentage_nue_propriete; //0
    public Decimal pourcentage_usufruit; //0
  }
  class cls_details_parts_vocation_titulaire {
    public Decimal pourcentage_directes; //0
    public Decimal pourcentage_indirectes; //0
    public cls_details_directes details_directes;
    public cls_details_indirectes details_indirectes;
  }
  class cls_details_directes {
    public Decimal pourcentage_pleine_propriete; //0
    public Decimal pourcentage_nue_propriete; //0
  }
  class cls_details_indirectes {
    public Decimal pourcentage_en_indivision; //0
    public Decimal pourcentage_en_personne_morale; //0
    public cls_details_en_indivision details_en_indivision;
    public cls_details_en_personne_morale details_en_personne_morale;
  }
  class cls_details_votes_directs {
    public Decimal pourcentage_pleine_propriete; //0
    public Decimal pourcentage_nue_propriete; //0
    public Decimal pourcentage_usufruit; //0
  }
  class cls_details_votes_indirects {
    public Decimal pourcentage_en_indivision; //0
    public Decimal pourcentage_en_personne_morale; //0
    public cls_details_en_indivision details_en_indivision;
    public cls_details_en_personne_morale details_en_personne_morale;
  }
  class cls_details_societe_de_gestion {
    public String nom; //string
    public String siren; //string
    public String greffe; //string
    public String adresse; //string
    public String code_postal; //string
    public String ville; //string
  }
  public class cls_depots_actes {
    public String date_depot; //2020-04-07
    public String date_depot_formate; //07/04/2020
    public boolean disponible;
    public String nom_fichier_pdf; //GOOGLE FRANCE - Actes du 07-04-2020.pdf
    public String token; //QTQ0MzA2MTg0MTIwMjAwNDA3RMOpY2lzaW9uKHMpIGRlIGwnYXNzb2Npw6kgdW5pcXVl
    public cls_actes[] actes;
  }
  public class cls_actes {
    public String type; //Décision(s) de l'associé unique
    public String decision; //Augmentation du capital social
    public String date_acte; //2020-03-04
    public String date_acte_formate; //04/03/2020
  }
  public class cls_comptes {
    public String date_depot; //2020-07-16
    public String date_depot_formate; //16/07/2020
    public String date_cloture; //2019-12-31
    public String annee_cloture; //2019
    public boolean confidentialite;
    public boolean confidentialite_compte_de_resultat;
    public boolean disponible;
    public String nom_fichier_pdf; //GOOGLE FRANCE - Comptes 2019.pdf
    public String token; //QzQ0MzA2MTg0MTIwMjAwNzE2
    public boolean disponible_xlsx;
    public String nom_fichier_xlsx; //GOOGLE FRANCE - Comptes 2019.xlsx
    public String token_xlsx; //ASQSMAA2MTg8MTIwMjAwNz2s
  }
  public class cls_publications_bodacc {
    public String numero_parution; //20200075
    public String dateBodac; //2020-04-16T00:00:00.000Z
    public String numero_annonce; //670
    public String bodacc; //B
    public String type; //Modification
    public String greffe; //Paris
    public String description;
    public String nom;
    public String prenom;
    public String nom_commercial;
  }
  class cls_procedures_collectives {
    public String type; //Redressement judiciaire
    public String date_debut; //2020-04-16T00:00:00.000Z
    public String date_fin; //2020-08-27T00:00:00.000Z
    //public cls_publications_bodacc[] publications_bodacc;
  }
  class cls_derniers_statuts {
    public String date_depot; //2020-04-07
    public String date_depot_formate; //07/04/2020
    public boolean disponible;
    public String nom_fichier_pdf; //GOOGLE FRANCE - Actes du 07-04-2020.pdf
    public String token; //QTQ0MzA2MTg0MTIwMjAwNDA3RMOpY2lzaW9uKHMpIGRlIGwnYXNzb2Npw6kgdW5pcXVl
    public String type; //Statuts mis à jour
    //public cls_decision decision;
    public String date_acte; //2020-03-04
    public String date_acte_formate; //04/03/2020
  }
  class cls_extrait_immatriculation {
    public String token; //SzQ0MzA2MTg0MQ
  }
  class cls_rnm {
    public String date_immatriculation; //2021-02-16T00:00:00.000Z
    public Date date_radiation;
    public String date_debut_activite; //2021-01-01T00:00:00.000Z
    public Date date_cessation_activite;
    public String chambre_des_metiers; //TARN-ET-GARONNE
    public String qualification; //ARTISAN
    public String derniere_mise_a_jour; //2021-02-22T00:00:00.000Z
  }
  class cls_marques {
    public String numero; //FR7103728
    public String date_enregistrement; //2008-12-04T00:00:00.000Z
    public String date_expiration; //2018-12-04T00:00:00.000Z
    public String lieu_enregistrement; //92 INPI - Dépôt électronique
    public String statut; //Marque enregistrée
    public String texte; //Google
    public String type; //Figurative
    public String lien_image; //https://data.inpi.fr/image/marques/FRXXXXXXXX
    public String descriptions;
    //public cls_classes[] classes;
    public cls_deposant deposant;
    public cls_mandataire mandataire;
    //public cls_evenements[] evenements;
  }

  class cls_classes {
    public Integer code; //35
    public String description; //Publicité ;  gestion des affaires commerciales ;  administration commerciale ;  travaux de bureau.
  }
  class cls_deposant {
    public String siren; //string
    public String entite_legale; //string
    public String nom; //string
    public String batiment; //string
    public String rue; //string
    public String ville; //string
    public String boite_postale; //string
    public String code_postal; //string
    public String code_pays; //string
  }
  class cls_mandataire {
    public String siren; //string
    public String entite_legale; //string
    public String nom; //string
    public String batiment; //string
    public String rue; //string
    public String ville; //string
    public String boite_postale; //string
    public String code_postal; //string
    public String code_pays; //string
  }
  class cls_evenements {
    public String type; //Publication
    public String identifiant_evenement; //string
    public String reference; //string
    public String dateEvenement; //2008-12-04T00:00:00.000Z
    public String numero_bopi; //2008-12
    public String date_bopi; //2008-12-04T00:00:00.000Z
    public String beneficiaire; //string
  }
  class cls_association {
    public Integer is_waldec; //1
    public String id_association; //W142005389
    public String id_ex_association; //0142004593
    public String denomination; //COMITÉ RÉGIONAL DE BRIDGE DE BASSE NORMANDIE
    public String siret; //95037097300014
    public Integer numero_rup;
    public String objet; //Grouper tous les clubs et joueurs de bridge de Basse-Normandie de soutenir leurs efforts et de développer sous toutes ses formes la pratique du jeu de bridge
    public Integer objet_social_1; //3589
    public String categorie_social_1; //Bridge, jeux de cartes, échecs, dames, jeux de société...
    public Integer objet_social_2; //0
    public String categorie_social_2; //Non connue
    public String date_creation; //1978-09-28
    public String date_derniere_declaration; //2019-09-18
    public String date_publication_creation; //1978-10-12
    public String date_declaration_dissolution; //2019-09-18
    public String groupement; //Simple
    public String position_activite; //Active
    public String nature; //Simplement Declarée
    public String site_web;
    public String telephone;
    public String email;
    public cls_adresse_siege adresse_siege;
    public cls_adresse_gestionnaire adresse_gestionnaire;
    public String observation; //Reprise auto =>  date publication création au JO à vérifier
    public String code_gestion; //142P
    public String dirigeant_civilite; //PM
    public String derniere_maj; //2020-03-18
    public cls_publications_joafe publications_joafe;
  }

  class cls_adresse_siege {
    public String code_postal; //14075
    public String code_insee; //14118
    public String ville; //Caen  cedex 05
    public String numero_voie; //115ter
    public String indice_repetition;
    public String type_voie; //BD
    public String libelle_voie; //Vanier  - La Pierre Heuzé
    public String complement_adresse;
    public String distribution; //_BP 75156
    public String adresse_ligne_1; //115ter BD Vanier  - La Pierre Heuzé
    public String adresse_ligne_2;
  }
  class cls_adresse_gestionnaire {
    //public cls_gestionnaire gestionnaire;
    public String code_postal; //14075
    public String ville; //CAEN
    public String distribution;
    public String adresse_ligne; //115TER  BOULEVARD VANIER  - LA PIERRE
    public String complement_adresse;
    public String indication;
    public String pays; //FRANCE
  }

  class cls_publications_joafe {
    public String numero_parution; //20180024
    public String date_parution; //2018-06-16
    public String date_declaration; //2018-06-12
    public Integer numero_annonce; //1766
    public String titre; //ASSOCIATION QUARTIER FOSSES-JEAN
    public String type; //Création
    public String prefecture; //Hauts-de-Seine
    public String objet; //la défense des droits des habitants du quartier auprès éventuellement des bailleurs sociaux ; aide à la gestion des problèmes de voisinage ; superviser le prêt des Lieux Communs de Résidences pour proposer des activités aux jeunes du quartier (jeux, échanges, anniversaires, prêt de livres ou divers) ; l'organisation de rencontres pluriculturelles (apprentissage de l'art culinaire des différentes ethnies qui composent le quartier) ; organisation de goûter et sorties, vide grenier annuel ou semestriel plus couramment brocante ; organisation de rencontres inter-générations retraités qui pourraient apporter une aide aux devoirs pour les enfants (bénévolement)
    public String site_web;
    public String adresse; //9, avenue D'Orgemont, 92700 Colombes
  }
}
