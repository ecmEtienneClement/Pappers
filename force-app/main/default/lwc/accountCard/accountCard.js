import { LightningElement, api } from "lwc";

export default class AccountCard extends LightningElement {
  @api account;
  nameSiret;

  connectedCallback() {
    if (this.account) {
      this.nameSiret =
        this.account.BillingAddress.country + " " + this.account.Siret__c;
    }
  }

  //
  edit() {
    const customeEvt = new CustomEvent("edit", {
      detail: this.account.Id
    });
    this.dispatchEvent(customeEvt);
  }

  //
  async viewAll() {
    let isParent = true;
    if (this.account.ParentId) isParent = false;
    //
    const customeEvt = new CustomEvent("viewall", {
      detail: { Id: this.account.ParentId, isParent }
    });
    this.dispatchEvent(customeEvt);
  }
}
