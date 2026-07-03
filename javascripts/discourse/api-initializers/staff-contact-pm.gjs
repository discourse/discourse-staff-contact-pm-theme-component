import { apiInitializer } from "discourse/lib/api";
import StaffContactPm from "../components/staff-contact-pm";

export default apiInitializer((api) => {
  api.renderInOutlet(
    "user-card-below-message-button",
    <template>
      <StaffContactPm @user={{@outletArgs.user}} @close={{@outletArgs.close}} />
    </template>
  );
});
