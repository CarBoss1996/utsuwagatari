---
description: "Workspace instructions for this Rails 7.2 app using MySQL, importmap, HAML, Bootstrap, simple_form, and Rails tooling."
---

# Workspace instructions

## What this project is

- Ruby on Rails application pinned to `rails ~> 7.2.2`.
- Uses MySQL via `mysql2`.
- Frontend is built with `importmap-rails`, Stimulus, Turbo, HAML, Bootstrap 5, and `simple_form`.
- No dedicated test suite directory is present in the repository today.

## Key commands

Use `bin/rails` for Rails CLI commands and `bundle exec` for analysis tools.

- Install dependencies
  - `bundle install`
- Database setup
  - `bin/rails db:create db:migrate`
- Start the app
  - `bin/rails server`
- Open a Rails console
  - `bin/rails console`
- Static analysis
  - `bundle exec rubocop`
  - `bundle exec brakeman`

## Conventions and style

- Preserve Rails conventions for controllers, models, and views.
- The repo uses HAML for view templates and `simple_form` for form building.
- Frontend assets are managed with `app/javascript/application.js` and `config/importmap.rb`.
- Use `config/initializers` for app-wide configuration.
- Keep secrets and credentials out of source control; this app uses Rails credentials and `config/storage.yml` hints.

## When editing code

- Prefer idiomatic Rails patterns over custom plumbing.
- Follow the existing app layout under `app/controllers`, `app/models`, `app/views`, and `app/javascript/controllers/`.
- Avoid introducing a separate JS bundler or Webpacker-style setup unless the user explicitly asks for one.
- If adding new assets, register them in `config/importmap.rb` and include them via `app/javascript/application.js`.

## Notes for Copilot behavior

- If asked to add tests, note that the repository currently has no `test/` or `spec/` folder.
- If asked to modify the database, prefer updating migrations and `db/schema.rb` if present.
- For new Rails generators, use `bin/rails generate` style commands and keep route changes in `config/routes.rb`.
- When asked about styling, use Bootstrap 5 and the existing `simple_form` Bootstrap integration.
