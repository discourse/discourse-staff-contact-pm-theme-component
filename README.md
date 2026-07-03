# Staff Contact PM

Staff Contact PM is a Discourse theme component that adds a Message button to selected staff user cards when the viewer cannot directly send private messages to that staff user.

This is useful for forums where `personal_message_enabled_groups` limits direct PM creation, but a public staff group such as `moderators` is configured with "Who can message this group?" set to "Everyone".

## Settings

- `contact_group`: group username used as the PM recipient. Defaults to `moderators`.
- `show_for_admins`: show the button on admin user cards. Defaults to enabled.
- `show_for_moderators`: show the button on moderator user cards. Defaults to enabled.

The component does not replace core's normal user PM button. If core already allows the viewer to message the user directly, this component renders nothing.
