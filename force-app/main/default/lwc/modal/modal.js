import { api } from "lwc";
import LightningModal from "lightning/modal";
import templateEditAccount from "./templates/templateEditAccount.html";
import templateViewAllAccount from "./templates/templateViewAllAccount.html";
import OBJECT_API_NAME from "@salesforce/schema/Account";
import NAME_FIELD from "@salesforce/schema/Account.Name";
import BILLING_COUNTRY_FIELD from "@salesforce/schema/Account.BillingCountry";
import BILLING_CITY_FIELD from "@salesforce/schema/Account.BillingCity";
import BILLING_STREET_FIELD from "@salesforce/schema/Account.BillingStreet";
//import BILLING_ADDRESS_FIELD from "@salesforce/schema/Account.BillingAddress";
import EFFECTIF_MAX_FIELD from "@salesforce/schema/Account.Effectif_Max__c";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import updateFromDataTableChild from "@salesforce/apex/accountData.updateFromDataTableChild";
import getAccountParentById from "@salesforce/apex/accountData.getAccountParentById";
import getAccountsChildByParentId from "@salesforce/apex/accountData.getAccountsChildByParentId";

export default class Modal extends LightningModal {
  @api accountId;
  @api isUpdate;
  @api isParent;
  parentAccount;
  childAccount;
  loader = true;
  //
  objectApiName;
  fields;
  columns;

  //
  connectedCallback() {
    if (this.isUpdate) {
      this.objectApiName = OBJECT_API_NAME;
      this.fields = [
        NAME_FIELD,
        BILLING_COUNTRY_FIELD,
        BILLING_CITY_FIELD,
        //  BILLING_ADDRESS_FIELD,
        EFFECTIF_MAX_FIELD
      ];
    } else {
      // eslint-disable-next-line @lwc/lwc/no-async-operation
      setTimeout(() => {
        if (this.isParent) {
          const loaded = this.getAccountChilds();
          if (loaded) this.loader = false;
        } else {
          const loaded = Promise.all([
            this.getAccountParent(),
            this.getAccountChilds()
          ]);
          if (loaded) this.loader = false;
        }
      }, 100);
      this.columns = [
        {
          label: "Name",
          fieldName: NAME_FIELD.fieldApiName,
          type: "text",
          editable: true
        },
        {
          label: "Billing Country",
          fieldName: BILLING_COUNTRY_FIELD.fieldApiName,
          type: "text",
          editable: true
        },
        {
          label: "Billing City",
          fieldName: BILLING_STREET_FIELD.fieldApiName,
          type: "text",
          editable: true
        },
        {
          label: "Effectif Max",
          fieldName: EFFECTIF_MAX_FIELD.fieldApiName,
          type: "number",
          editable: true
        }
      ];
    }
  }
  //
  render() {
    return this.isUpdate ? templateEditAccount : templateViewAllAccount;
  }
  //
  async getAccountParent() {
    this.parentAccount = await getAccountParentById({
      parentId: this.accountId
    });
  }
  //
  async getAccountChilds() {
    this.childAccount = await getAccountsChildByParentId({
      parentId: this.accountId
    });
  }
  //
  editSuccess() {
    const customToast = new ShowToastEvent({
      title: "Edit account",
      massage: "Edit account success !",
      variant: "success"
    });
    this.dispatchEvent(customToast);
    this.close(true);
  }

  async editChildAccount(evt) {
    const paramAccountsList = evt.detail.draftValues;
    try {
      const responseReq = await updateFromDataTableChild({ paramAccountsList });
      if (responseReq) {
        const customToast = new ShowToastEvent({
          title: "Edit account(s)",
          massage: "Edit account(s) success !",
          variant: "success"
        });
        this.dispatchEvent(customToast);
      } else {
        this.handleError();
      }
    } catch (error) {
      this.handleError(error);
    }
  }
  //
  cancel() {
    this.close(false);
  }
  //
  handleError(error) {
    const customToast = new ShowToastEvent({
      title: "Edit account(s)",
      massage: "Edit account(s) error !",
      variant: "error"
    });
    this.dispatchEvent(customToast);
    console.log(JSON.stringify(error));
  }
}
