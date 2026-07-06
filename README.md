# Contact PM

Contact PM is a Discourse theme component that adds a Message button to selected user cards when the viewer cannot directly send private messages to that user.

This is useful for forums where `personal_message_enabled_groups` limits direct PM creation, but a public contact group such as `moderators` or `support` is configured with "Who can message this group?" set to "Everyone".

## Settings

- `contact_pm_routes`: user-card contact PM routes.

Each route can match one or more staff roles, or an exact username. The first matching route is used.

The default route matches staff users and opens a PM to `moderators`:

```yaml
- name: staff
  staff: true
  contact_group: moderators
```

For a non-staff support contact user, add a username route:

```yaml
- name: support
  username: support_user
  contact_group: support
```

The component does not replace core's normal user PM button. If core already allows the viewer to message the user directly, this component renders nothing.
