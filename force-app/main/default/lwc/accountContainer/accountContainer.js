import { LightningElement } from "lwc";
import Modal from "c/modal";
export default class AccountContainer extends LightningElement {
  delayTimeout;

  //
  handleKeyUp(evt) {
    const paramQuery = evt.detail;
    if (!paramQuery) {
      this.template.querySelector("c-accounts-list").accountSaveAfterSearch();
      return;
    }

    clearTimeout(this.delayTimeout);
    // eslint-disable-next-line @lwc/lwc/no-async-operation
    this.delayTimeout = setTimeout(() => {
      this.template
        .querySelector("c-accounts-list")
        .accountSearchList(paramQuery);
    }, 500);
  }

  //
  async onEditContainer(evt) {
    await Modal.open({
      size: "small",
      description: "ma description",
      accountId: evt.detail,
      isUpdate: true
    });
  }
  //
  async onViewAllContainer(evt) {
    const accountId = evt.detail.Id;
    const isParent = evt.detail.isParent;
    await Modal.open({
      size: "small",
      description: "ma description",
      accountId,
      isUpdate: false,
      isParent
    });
  }
}
