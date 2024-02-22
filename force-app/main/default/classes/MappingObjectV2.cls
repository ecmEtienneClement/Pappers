public with sharing class MappingObjectV2 implements IMappingObject {
  public MappingObjectV2() {
  }

  public void mapper(Pappers.JSON2ApexClass_Salesforcecody responseObject) {
    Account accParent = MappingObject.mapDataAccountParent(responseObject);
    if (accParent != null) {
      upsert accParent;
      if (accParent.Id != null) {
        // Ajout des etablissements
        if (responseObject.etablissements.size() > 0) {
          mapEtablissements(responseObject.etablissements, accParent);
        }
        // Ajout des representants
        if (responseObject.representants.size() > 0) {
          mapRepresentants(responseObject.representants, accParent);
        }
        // Ajout Beneficiaires
        if (responseObject.beneficiaires_effectifs.size() > 0) {
          mappingBeneficiaires(
            responseObject.beneficiaires_effectifs,
            accParent
          );
        }
        // Ajout Finances
        if (responseObject.finances.size() > 0) {
          mappingFinances(responseObject.finances, accParent);
        }
        //Ajout Annonces Bodacc
        if (responseObject.publications_bodacc.size() > 0) {
          mappingPublicationBodacc(
            responseObject.publications_bodacc,
            accParent
          );
        }
        //Ajout Depots actes
        if (responseObject.depots_actes.size() > 0) {
          mappingDepotsActes(responseObject.depots_actes, accParent);
        }
        // Ajout Compte sociaux
        if (responseObject.comptes.size() > 0) {
          mappingCompte(responseObject.comptes, accParent);
        }
      }
    }
  }

  public static Account mapDataAccountParent(
    Pappers.JSON2ApexClass_Salesforcecody dataParams
  ) {
    Account primaireAccount = new Account();

    primaireAccount.SIREN__c = dataParams.siren;
    primaireAccount.Name = dataParams.nom_entreprise;
    primaireAccount.Domaine_d_activite__c = dataParams.domaine_activite;
    primaireAccount.Objet_Social__c = dataParams.objet_social;
    primaireAccount.Domaine_d_activite__c = dataParams.domaine_activite;
    if (dataParams.date_cessation != null) {
      primaireAccount.Date_de_Cessation__c = date.valueOf(
        dataParams.date_cessation
      );
    }
    if (dataParams.categorie_juridique != null) {
      primaireAccount.Categorie_Juridique__c = Integer.valueOf(
        dataParams.categorie_juridique
      );
    }
    primaireAccount.Forme_Juridique__c = dataParams.forme_juridique;
    primaireAccount.Societ_a_mission__c = dataParams.societe_a_mission;
    if (dataParams.annee_effectif != null) {
      primaireAccount.Annee_Effectif__c = Integer.valueOf(
        dataParams.annee_effectif
      );
    }

    primaireAccount.Capital__c = dataParams.capital;
    primaireAccount.Economie_Sociale_et_Solidaire__c = dataParams.economie_sociale_solidaire;
    if (dataParams.derniere_mise_a_jour_rne != null) {
      primaireAccount.Date_Radiation_RNE__c = date.valueOf(
        dataParams.derniere_mise_a_jour_rne
      );
    }

    primaireAccount.Status_RCS__c = dataParams.statut_rcs;
    primaireAccount.Numero_RCS__c = dataParams.numero_rcs;
    if (dataParams.date_immatriculation != null) {
      primaireAccount.Date_Immatriculation_RCS__c = date.valueOf(
        dataParams.date_immatriculation
      );
    }

    primaireAccount.Date_de_Radiation_RCS__c = dataParams.date_radiation;
    primaireAccount.Status_RNE__c = dataParams.statut_rne;
    if (dataParams.date_immatriculation_rne != null) {
      primaireAccount.Date_Immatriculation_RNE__c = Date.valueOf(
        dataParams.date_immatriculation_rne
      );
    }

    primaireAccount.Numero_TVA__c = dataParams.numero_tva_intracommunautaire;
    if (dataParams.siege.nic != null) {
      primaireAccount.NIC__c = Double.valueOf(dataParams.siege.nic);
    }

    primaireAccount.Domaine_d_activite__c = dataParams.domaine_activite;
    primaireAccount.Objet_Social__c = dataParams.domaine_activite;
    if (dataParams.date_creation != null) {
      primaireAccount.Date_de_Creation__c = Date.valueOf(
        dataParams.date_creation
      );
    }
    if (dataParams.categorie_juridique != null) {
      primaireAccount.Categorie_Juridique__c = Decimal.valueOf(
        dataParams.categorie_juridique
      );
    }

    primaireAccount.Forme_Juridique__c = dataParams.forme_juridique;
    primaireAccount.Societ_a_mission__c = dataParams.societe_a_mission;

    //Siege correspond adresse
    primaireAccount.Code_NAF__c = dataParams.siege.code_naf;
    primaireAccount.Siret__c = dataParams.siege.siret;
    primaireAccount.Libelle_NAF__c = dataParams.siege.libelle_code_naf;
    // primaireAccount.Date_de_Creation__c = date.valueOf(dataParams.siege.date_creation);
    primaireAccount.Effectif_Min__c = dataParams.siege.effectif_min;
    primaireAccount.Effectif_Max__c = dataParams.siege.effectif_max;
    primaireAccount.BillingCity = dataParams.siege.ville;
    primaireAccount.BillingCountry = dataParams.siege.pays;
    primaireAccount.BillingStreet = dataParams.siege.adresse_ligne_1;
    primaireAccount.BillingPostalCode = dataParams.siege.code_postal;
    primaireAccount.BillingLatitude = dataParams.siege.latitude;
    primaireAccount.BillingLongitude = dataParams.siege.longitude;

    /* primaireAccount.BillingAddress.City = dataParams.siege.ville;*/
    if (dataParams.siege.date_cessation != null) {
      primaireAccount.Date_de_Cessation__c = Date.valueOf(
        dataParams.siege.date_cessation
      );
    }

    System.debug('***** primaire mapDataAccountParent *** ' + primaireAccount);
    return primaireAccount;
  }

  public static void mapEtablissements(
    List<Pappers.cls_etablissements> inputEtablissements,
    Account parentAccount
  ) {
    List<Account> listEtablissement = new List<Account>();
    for (Pappers.cls_etablissements etablissement : inputEtablissements) {
      Account secondaireAccount = new Account();
      secondaireAccount.ParentId = parentAccount.Id;
      secondaireAccount.Siret__c = etablissement.siret;
      secondaireAccount.Name =
        etablissement.code_postal +
        '-' +
        etablissement.ville +
        '-' +
        (etablissement.enseigne != null
          ? etablissement.enseigne
          : parentAccount.Name);
      if (etablissement.nic != null) {
        secondaireAccount.NIC__c = Double.valueOf(etablissement.nic);
      }

      secondaireAccount.BillingCity = etablissement.ville;
      secondaireAccount.BillingCountry = etablissement.pays;
      secondaireAccount.BillingStreet = etablissement.adresse_ligne_1;
      secondaireAccount.BillingPostalCode = etablissement.code_postal;
      secondaireAccount.BillingLatitude = etablissement.latitude;
      secondaireAccount.BillingLongitude = etablissement.longitude;
      secondaireAccount.Code_NAF__c = etablissement.code_naf;
      secondaireAccount.Libelle_NAF__c = etablissement.libelle_code_naf;
      secondaireAccount.Effectif_Min__c = etablissement.effectif_min;
      secondaireAccount.Effectif_Max__c = etablissement.effectif_max;
      if (etablissement.annee_effectif != null) {
        secondaireAccount.Annee_Effectif__c = Integer.valueOf(
          etablissement.annee_effectif
        );
      }
      if (etablissement.date_de_creation != null) {
        secondaireAccount.Date_de_Creation__c = date.valueOf(
          etablissement.date_de_creation
        );
      }
      if (etablissement.date_cessation != null) {
        secondaireAccount.Date_de_Cessation__c = date.valueOf(
          etablissement.date_cessation
        );
      }
      listEtablissement.add(secondaireAccount);
      System.debug(
        '***** etablissement etablissement *** ' + secondaireAccount
      );
    }
    if (listEtablissement.size() > 0) {
      upsert listEtablissement;
    }
  }

  public static Boolean mapRepresentants(
    List<Pappers.cls_representants> representants,
    Account parentAccount
  ) {
    List<RecordType> accountsRecordTypes = [
      SELECT Id, IsPersonType
      FROM RecordType
      WHERE SobjectType = 'Account'
      ORDER BY IsPersonType
    ];

    String recordTypeIdComptePersMorale = accountsRecordTypes[0].Id;
    String recordTypeIdPersonneAccount = accountsRecordTypes[1].Id;

    Map<String, Account> mapAccount = new Map<String, Account>();
    Map<String, Representants__c> mapRepres = new Map<String, Representants__c>();

    for (Integer i = 0; i < representants.size(); i++) {
      Account ac = new Account();
      Representants__c rpr = new Representants__c();

      rpr.Qualite__c = representants[i].qualite;
      rpr.Date_de_Prise_de_Poste__c = Date.valueOf(
        representants[i].date_prise_de_poste
      );
      rpr.AccountId__c = parentAccount.Id;

      if (representants[i].personne_morale) {
        ac.FirstName = representants[i].prenom;
        ac.LastName = representants[i].nom != null
          ? representants[i].nom
          : 'Missing name';
        ac.Salutation = (representants[i].sexe == 'M') ? 'Mr' : 'Mrs';
        ac.PersonBirthdate = (representants[i].date_de_naissance != null)
          ? Date.valueOf(representants[i].date_de_naissance)
          : null;
        ac.PersonMailingCity = representants[i].ville;
        ac.PersonMailingCountry = representants[i].pays;
        ac.PersonMailingStreet = representants[i].adresse_ligne_1;
        ac.PersonMailingPostalCode = representants[i].code_postal;
        ac.RecordTypeId = recordTypeIdPersonneAccount;
      } else {
        ac.Name = representants[i].nom_complet;
        ac.SIREN__c = representants[i].siren;
        ac.Forme_Juridique__c = representants[i].forme_juridique;
        ac.BillingCity = representants[i].ville;
        ac.BillingCountry = representants[i].pays;
        ac.BillingStreet = representants[i].adresse_ligne_1;
        ac.BillingPostalCode = representants[i].code_postal;
        ac.RecordTypeId = recordTypeIdComptePersMorale;
      }
      mapAccount.put('ref' + i, ac);
      mapRepres.put('ref' + i, rpr);
    }
    insert mapAccount.values();
    for (String ref : mapAccount.keySet()) {
      mapRepres.get(ref).Compte__c = mapAccount.get(ref).Id;
    }
    insert mapRepres.values();
    return true;
  }

  public static void mappingBeneficiaires(
    List<Pappers.cls_beneficiaires_effectifs> beneficiaires,
    Account parentAccount
  ) {
    List<BeneficiaireEffectif__c> listbeneficiaires = new List<BeneficiaireEffectif__c>();
    for (Pappers.cls_beneficiaires_effectifs beneficiaire : beneficiaires) {
      BeneficiaireEffectif__c beneficiaire = new BeneficiaireEffectif__c();

      beneficiaire.Date_Greffe__c = (beneficiaire.date_greffe != null)
        ? Date.valueOf(beneficiaire.date_greffe)
        : null;
      beneficiaire.Type__c = (beneficiaire.type != null)
        ? beneficiaire.type
        : '';
      beneficiaire.Name = beneficiaire.prenom + ' ' + beneficiaire.nom;
      beneficiaire.Comptes__c = parentAccount.Id;
      beneficiaire.PctParts__c = beneficiaire.pourcentage_parts;
      beneficiaire.PctPartsDirectes__c = beneficiaire
        .pourcentage_parts_directes;
      beneficiaire.PctPartsIndirectes__c = beneficiaire
        .pourcentage_parts_indirectes;
      beneficiaire.PctPartsVocationTitulaire__c = beneficiaire
        .pourcentage_parts_vocation_titulaire;
      beneficiaire.PctVotes__c = beneficiaire.pourcentage_votes;
      beneficiaire.PctVotesDirects__c = beneficiaire.pourcentage_votes_directs;
      beneficiaire.PctVotesIndirect__c = beneficiaire
        .pourcentage_votes_indirect;
      beneficiaire.PouvoirDecisionAG__c = beneficiaire
        .detention_pouvoir_decision_ag;
      beneficiaire.AutresMoyensControle__c = beneficiaire
        .detention_autres_moyens_controle;
      beneficiaire.RepLegal__c = beneficiaire.beneficiaire_representant_legal;

      listbeneficiaires.add(beneficiaire);
    }
    if (listbeneficiaires.size() > 0)
      upsert listbeneficiaires;
  }

  public static void mappingFinances(
    List<Pappers.cls_finances> listFinances,
    Account parentAccount
  ) {
    List<Finance__c> finances = new List<Finance__c>();
    for (Pappers.cls_finances finance : listFinances) {
      Finance__c f = new Finance__c();
      f.Annee__c = finance.annee;
      f.AutonomieFinanciere__c = finance.capacite_autofinancement;
      f.BFR__c = finance.BFR;
      f.BFRExploitation__c = finance.BFR_exploitation;
      f.BFRExploitationJoursCA__c = finance.BFR_exploitation_jours_CA;
      f.BFRHorsExploitation__c = finance.BFR_hors_exploitation;
      f.BFRHorsExploitationJoursCA__c = finance.BFR_hors_exploitation_jours_CA;
      f.BFRJoursCA__c = finance.BFR_jours_CA;
      f.CapaciteAutofinancement__c = finance.capacite_autofinancement;
      f.CapaciteAutofinancementCA__c = finance.capacite_autofinancement_CA;
      f.CapaciteRemboursement__c = finance.capacite_remboursement;
      f.ChiffreAffaire__c = finance.chiffre_affaires;
      f.AccountId__c = parentAccount.Id;
      f.CouvertureBFR__c = finance.couverture_BFR;
      f.CouvertureDettes__c = finance.couverture_dettes;
      f.DelaiPaiementClientsJours__c = finance.delai_paiement_clients_jours;
      f.DelaiPaiementFournisseursJours__c = finance
        .delai_paiement_fournisseurs_jours;
      f.DettesFinancieres__c = finance.dettes_financieres;
      f.Effectif__c = finance.effectif;
      f.EtatDettes1AnAuPlus__c = finance.etat_dettes_1_an_au_plus;
      f.ExcedentBrutExploitation__c = finance.excedent_brut_exploitation;
      f.fondsRoulementNetGlobal__c = finance.fonds_roulement_net_global;
      f.ImpotsTaxes__c = finance.impots_taxes;
      f.LiquiditeGenerale__c = finance.liquidite_generale;
      f.MargeBrute__c = finance.marge_brute;
      f.Marge_Nette__c = (finance.marge_nette != null)
        ? finance.marge_nette
        : 0;
      f.RatioEndettement__c = finance.ratio_endettement;
      f.RatioStockCAJours__c = finance.ratio_stock_CA_jours;
      f.RentabiliteEconomique__c = finance.rentabilite_economique;
      f.RentabiliteFondsPropres__c = finance.rentabilite_fonds_propres;
      f.ResultatExploitation__c = finance.resultat_exploitation;
      f.SalairesCA__c = finance.salaires_CA;
      f.SalairesChargesSociales__c = finance.salaires_charges_sociales;
      f.TauxCroissanceChiffreAffaires__c = finance
        .taux_croissance_chiffre_affaires;
      f.TauxLevier__c = finance.taux_levier;
      f.TauxMargeBrute__c = finance.taux_marge_brute;
      f.TauxMargeEBITDA__c = finance.taux_marge_EBITDA;
      f.TauxMargeOperationnelle__c = finance.taux_marge_operationnelle;
      f.Tresorerie__c = finance.tresorerie;
      f.ValeurAjoutee__c = finance.valeur_ajoutee;
      f.ValeurAjouteeCA__c = finance.valeur_ajoutee_CA;
      finances.add(f);
    }

    if (finances.size() > 0)
      upsert finances;
  }

  public static void mappingPublicationBodacc(
    List<Pappers.cls_publications_bodacc> listbodac,
    Account parentAccount
  ) {
    List<PublicationBodacc__c> listPublicationBodaccs = new List<PublicationBodacc__c>();
    for (Pappers.cls_publications_bodacc bodac : listbodac) {
      PublicationBodacc__c pubBodac = new PublicationBodacc__c();

      pubBodac.AccountId__c = parentAccount.Id;
      pubBodac.DateDePublication__c = (bodac.dateBodac != null)
        ? Date.valueOf(bodac.dateBodac)
        : null;
      pubBodac.Desription__c = bodac.description;
      pubBodac.Name = bodac.nom_commercial != null
        ? bodac.nom_commercial
        : bodac.nom + ' - ' + bodac.prenom;
      pubBodac.Ref_BODACC__c = bodac.numero_parution;
      pubBodac.Type__c = bodac.type;

      listPublicationBodaccs.add(pubBodac);
    }

    if (listPublicationBodaccs.size() > 0) {
      upsert listPublicationBodaccs;
    }
  }

  public static void mappingDepotsActes(
    list<Pappers.cls_depots_actes> listdepotActes,
    Account parentAccount
  ) {
    Map<String, DepotActe__c> mapdepotsActes = new Map<String, DepotActe__c>();
    Map<String, list<Acte__c>> mapActes = new Map<String, list<Acte__c>>();

    for (Integer i = 0; i < listdepotActes.size(); i++) {
      DepotActe__c depotActe = new DepotActe__c();
      depotActe.AccountId__c = parentAccount.Id;
      depotActe.DateDeDepot__c = (listdepotActes[i].date_depot != null)
        ? Date.valueOf(listdepotActes[i].date_depot)
        : null;
      depotActe.Name = listdepotActes[i].nom_fichier_pdf;
      depotActe.Fichier__c = listdepotActes[i].nom_fichier_pdf;
      mapdepotsActes.put('ref' + i, depotActe);
      if (listdepotActes[i].actes.size() > 0) {
        list<Acte__c> listActes = new List<Acte__c>();
        for (Integer j = 0; j < listdepotActes[i].actes.size(); j++) {
          Acte__c actes = new Acte__c();
          actes.AccountId__c = parentAccount.Id;
          actes.Date_Acte__c = (listdepotActes[i].actes[j].date_acte != null)
            ? Date.valueOf(listdepotActes[i].actes[j].date_acte)
            : null;
          actes.Decision__c = listdepotActes[i].actes[j].decision;
          actes.Type__c = listdepotActes[i].actes[j].type;
          listActes.add(actes);
          mapActes.put('ref' + i, listActes);
        }
      }
    }
    if (mapdepotsActes.values().size() > 0) {
      upsert mapdepotsActes.values();
      if (mapActes.KeySet().size() > 0) {
        List<Acte__c> lesActes = new List<Acte__c>();
        for (String ref : mapActes.KeySet()) {
          for (Acte__c act : mapActes.get(ref)) {
            act.DepotActeId__c = mapdepotsActes.get(ref).Id;
            lesActes.add(act);
          }
        }
        if (lesActes.size() > 0) {
          upsert lesActes;
        }
      }
    }
  }

  public static void mappingCompte(
    List<Pappers.cls_comptes> mesComptes,
    Account parentAccount
  ) {
    List<Comptes_Sociaux__c> listComptes = new List<Comptes_Sociaux__c>();
    for (Pappers.cls_comptes compte : mesComptes) {
      Comptes_Sociaux__c compte = new Comptes_Sociaux__c();
      compte.AccountId__c = parentAccount.id;
      compte.Annee__c = compte.annee_cloture;
      compte.Name = compte.nom_fichier_pdf;
      compte.DateDeDepot__c = (compte.date_depot != null)
        ? Date.valueOf(compte.date_depot)
        : null;
      compte.Lien_Fichier_Excel__c = compte.nom_fichier_xlsx;
      compte.Lien_Fichier_PDF__c = compte.nom_fichier_pdf;
      compte.Ref_Compte__c = compte.token;
      listComptes.add(compte);
    }
    if (listComptes.size() > 0) {
      upsert listComptes;
    }
  }
}
