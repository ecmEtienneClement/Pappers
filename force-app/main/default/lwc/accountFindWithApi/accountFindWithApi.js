//import launchBatch from "@salesforce/apex/AccountApiPappers.launchBatch";
import { LightningElement } from "lwc";
import ModalFindAccount from "c/modalFindAccount";
import getAccountBySiret from "@salesforce/apex/AccountApiPappers.getAccountBySiret";

export default class AccountFindWithApi extends LightningElement {
  inputSiret = "";

  //
  handleInputSiret(evt) {
    this.inputSiret = evt.target.value;
  }
  //
  async handleClick() {
    if (this.inputSiret !== "") {
      const inputSiret = this.inputSiret;
      const accountResult = await getAccountBySiret({
        inputSiret
      });

      if (accountResult.length === 1) {
        await ModalFindAccount.open({
          description: "Le modal du compte existent",
          size: "smail",
          account: accountResult[0]
        });
      } else {
        console.log("Le compte new =>");

        //   launchBatch({ inputSiret });
      }
    }
  }
}
