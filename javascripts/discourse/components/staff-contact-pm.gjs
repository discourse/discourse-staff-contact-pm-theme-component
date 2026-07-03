import Component from "@glimmer/component";
import { action } from "@ember/object";
import { service } from "@ember/service";
import { settings } from "virtual:theme";
import DButton from "discourse/ui-kit/d-button";

export default class StaffContactPm extends Component {
  @service composer;
  @service currentUser;

  get contactGroup() {
    return settings.contact_group?.trim();
  }

  get targetsStaffCard() {
    const user = this.args.user;

    return (
      (settings.show_for_admins && user?.admin) ||
      (settings.show_for_moderators && user?.moderator)
    );
  }

  get shouldShow() {
    return (
      this.currentUser &&
      this.contactGroup &&
      this.targetsStaffCard &&
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
