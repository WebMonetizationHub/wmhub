# Wmhub

## Entities

- Users
  - Name, Email, etc...
- UsersPointers
  - PaymentPointer
  - Active?
  - UserID
- Templates
  - Type (PAYMENT_STARTED, PAYMENT_STOPPED, PAYMENT_UNAVAILABLE)
  - Name
  - Content
  - UserID
- Triggers
  - Type (PAYMENT_STARTED, PAYMENT_STOPPED, PAYMENT_UNAVAILABLE)
  - Selector CSS
  - Action (SHOW, HIDE)
  - UserID
- Projects
  - Name
  - Description
  - URL
  - Tags
  - Discoverable?
- ProjectsTemplates
  - TemplateID
  - ProjectID
- ProjectsTriggers
  - TriggerID
  - ProjectID
- ProjectsPointers
  - ProjectID
  - PaymentPointer
  - Active?
  - Weight
- ProjectPayments
  - ProjectID
  - PaymentID 
  - Amount
  - AssetScale
  - AssetCode

## Contexts

- UserContext
  - get_user_with_pointers!(id)
  - create_user(%User{})
  - update_user(%User{})
  - add_pointer(%User{}, %Pointer{})
- TemplateContext
  - add_template(%User{}, template_params)
- TriggerContext
  - add_trigger(%User{}, trigger_params)
- ProjectContext
  - list_projects_for_user(%User{})
  - add_pointer(%Project{}, %Pointer{})
  - assign_trigger(%Project{}, %Trigger{})
  - assign_template(%Project{}, %Template{})
  - get_active_pointers(%Project{})
  - register_payment(%Project{}, payment_params)
- AccountsContext
  - things related with tokens/login/auth/etc (mix phx.gen.auth?)

## Features

### Automatic Web Monetization!

Drop your customized WMHub code and be done with it. No need to append &lt;meta&gt; tags or write JS. We do the heavy lifting for you!

### Web Monetization automation

Stop writing JS to do simple Web Monetization tasks. WMHub allows you to show templates, hide content, hide ads for Web Monetization users, and more without writing a single line of JS!

### Probabilistic revenue sharing

Allows you to assign multiple pointers to a project and fairly assign pointers on page views. This works on a per-project basis. Updates to pointers for projects update in real time!

### Get updates for your page views

As soon as people start streaming payments, you can follow-up in your project's dashboard.

### Show your work

We are a hub, so with your permission, people will discover your project! Tag it and enjoy the distribution.
