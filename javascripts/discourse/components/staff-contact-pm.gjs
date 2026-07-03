import Component from "@glimmer/component";
import { action } from "@ember/object";
import { service } from "@ember/service";
import { settings } from "virtual:theme";
import DButton from "discourse/ui-kit/d-button";

export default class StaffContactPm extends Component {
  @service composer;
  @service currentUser;

  get matchingRoute() {
    const user = this.args.user;
    const routes = settings.contact_pm_routes ?? [];

    return routes.find((route) => {
      const contactGroup = route.contact_group?.trim();

      if (!contactGroup) {
        return false;
      }

      if (route.username?.trim()) {
        return (
          route.username.trim().toLowerCase() === user?.username?.toLowerCase()
        );
      }

      return (
        (route.staff && user?.staff) ||
        (route.admins && user?.admin) ||
        (route.moderators && user?.moderator)
      );
    });
  }

  get contactGroup() {
    return this.matchingRoute?.contact_group?.trim();
  }

  get shouldShow() {
    return (
      this.currentUser?.id &&
      this.contactGroup &&
      !this.args.user?.can_send_private_message_to_user
    );
  }

  @action
  composeMessage() {
    this.args.close?.();

    this.composer.openNewMessage({
      recipients: this.contactGroup,
      hasGroups: true,
    });
  }

  <template>
    {{#if this.shouldShow}}
      <li class="staff-contact-pm__item">
        <DButton
          @action={{this.composeMessage}}
          @icon="envelope"
          @label="user.private_message"
          class="btn-primary staff-contact-pm__button"
        />
      </li>
    {{/if}}
  </template>
}
