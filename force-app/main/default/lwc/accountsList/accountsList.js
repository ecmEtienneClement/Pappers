import { LightningElement, api, wire } from "lwc";
import getAccounts from "@salesforce/apex/accountData.getAccounts";
import accountSearch from "@salesforce/apex/accountData.accountSearch";
//
export default class AccountsList extends LightningElement {
  accounts;
  accountsSearchIsNull;
  accountsSave;
  //Get all Contacts
  @wire(getAccounts)
  getAccounts({ data, error }) {
    if (data) {
      this.accounts = data;
      this.accountsSave = data;
    } else {
      console.log(JSON.stringify(error));
    }
  }

  //Get All By Name, Siret, SIREN  Search
  @api
  async accountSearchList(paramQuerySearch) {
    const paramQuery = paramQuerySearch + "%";
    try {
      const accountsSearch = await accountSearch({ paramQuery });
      this.accounts = accountsSearch;
      // eslint-disable-next-line no-unused-expressions
      accountsSearch.length === 0
        ? (this.accountsSearchIsNull = true)
        : (this.accountsSearchIsNull = false);
    } catch (error) {
      console.log(JSON.stringify(error));
    }
  }

  // Restaure Account Save After Search
  @api
  accountSaveAfterSearch() {
    this.accounts = this.accountsSave;
  }

  //
  onEditList(evt) {
    this.dispatcherEvent("edit", evt.detail);
  }
  //
  onViewAllList(evt) {
    this.dispatcherEvent("viewall", evt.detail);
  }

  //
  dispatcherEvent(nameEvt, paramEvt) {
    const customeEvt = new CustomEvent(nameEvt, {
      detail: paramEvt
    });
    this.dispatchEvent(customeEvt);
  }
}
