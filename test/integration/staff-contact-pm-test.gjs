import Service from "@ember/service";
import { click, render } from "@ember/test-helpers";
import { module, test } from "qunit";
import { settings } from "virtual:theme";
import PluginOutlet from "discourse/components/plugin-outlet";
import lazyHash from "discourse/helpers/lazy-hash";
import { setupRenderingTest } from "discourse/tests/helpers/component-test";
import StaffContactPm from "../../discourse/components/staff-contact-pm";

const ADMIN = {
  username: "admin",
  admin: true,
  moderator: false,
  can_send_private_message_to_user: false,
};

const MODERATOR = {
  username: "moderator",
  admin: false,
  moderator: true,
  can_send_private_message_to_user: false,
};

const USER = {
  username: "member",
  admin: false,
  moderator: false,
  can_send_private_message_to_user: false,
};

class ComposerStub extends Service {
  openNewMessage(options) {
    this.options = options;
  }
}

module("Integration | Component | staff-contact-pm", function (hooks) {
  setupRenderingTest(hooks);

  hooks.beforeEach(function () {
    settings.contact_group = "moderators";
    settings.show_for_admins = true;
    settings.show_for_moderators = true;

    this.owner.register("service:composer", ComposerStub);
  });

  test("renders a Message button for an admin card when direct user PMs are unavailable", async function (assert) {
    this.user = ADMIN;

    await render(<template><StaffContactPm @user={{this.user}} /></template>);

    assert
      .dom(".staff-contact-pm__button")
      .exists("adds the fallback staff contact PM button");
    assert
      .dom(".staff-contact-pm__button .d-icon-envelope")
      .exists("uses the core PM envelope icon");
  });

  test("renders a Message button for a moderator card when direct user PMs are unavailable", async function (assert) {
    this.user = MODERATOR;

    await render(<template><StaffContactPm @user={{this.user}} /></template>);

    assert.dom(".staff-contact-pm__button").exists();
  });

  test("opens a PM to the configured contact group", async function (assert) {
    settings.contact_group = "staff_contact";
    this.user = MODERATOR;

    await render(<template><StaffContactPm @user={{this.user}} /></template>);
    await click(".staff-contact-pm__button");

    assert.deepEqual(this.owner.lookup("service:composer").options, {
      recipients: "staff_contact",
      hasGroups: true,
    });
  });

  test("closes the user card before opening the composer", async function (assert) {
    this.user = MODERATOR;
    this.close = () => assert.step("closed");

    await render(
      <template>
        <StaffContactPm @user={{this.user}} @close={{this.close}} />
      </template>
    );
    await click(".staff-contact-pm__button");

    assert.verifySteps(["closed"]);
  });

  test("does not render for regular user cards", async function (assert) {
    this.user = USER;

    await render(<template><StaffContactPm @user={{this.user}} /></template>);

    assert.dom(".staff-contact-pm__button").doesNotExist();
  });

  test("does not render when core already allows direct PMs to the user", async function (assert) {
    this.user = {
      ...MODERATOR,
      can_send_private_message_to_user: true,
    };

    await render(<template><StaffContactPm @user={{this.user}} /></template>);

    assert.dom(".staff-contact-pm__button").doesNotExist();
  });

  test("does not render when the matching staff role is disabled", async function (assert) {
    settings.show_for_moderators = false;
    this.user = MODERATOR;

    await render(<template><StaffContactPm @user={{this.user}} /></template>);

    assert.dom(".staff-contact-pm__button").doesNotExist();
  });

  test("does not render without a contact group", async function (assert) {
    settings.contact_group = "   ";
    this.user = MODERATOR;

    await render(<template><StaffContactPm @user={{this.user}} /></template>);

    assert.dom(".staff-contact-pm__button").doesNotExist();
  });

  test("wires into the user-card outlet via outletArgs.user", async function (assert) {
    this.user = MODERATOR;

    await render(
      <template>
        <PluginOutlet
          @name="user-card-below-message-button"
          @outletArgs={{lazyHash user=this.user}}
        />
      </template>
    );

    assert.dom(".staff-contact-pm__button").exists();
  });
});

module(
  "Integration | Component | staff-contact-pm (anonymous)",
  function (hooks) {
    setupRenderingTest(hooks, { anonymous: true });

    hooks.beforeEach(function () {
      settings.contact_group = "moderators";
      settings.show_for_admins = true;
      settings.show_for_moderators = true;
    });

    test("does not render for anonymous visitors", async function (assert) {
      this.user = MODERATOR;

      await render(<template><StaffContactPm @user={{this.user}} /></template>);

      assert.dom(".staff-contact-pm__button").doesNotExist();
    });
  }
);
