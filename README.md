# GuideRails

An interactive Ruby on Rails documentation assistant. Ask a Rails question in plain English and get an answer that is **read out of the official Rails Guides**, not recalled from the model's memory.

Most AI coding assistants answer Rails questions from whatever they absorbed during training, which means confidently invented method names and configuration options that were removed three versions ago. GuideRails takes a different approach: before answering, the model looks up the guide index, picks the guide that matches your question, fetches it, and answers from what it just read.

## How it works

When you send a message, the assistant is given two tools and is instructed to use them on every Rails question:

| Tool | What it does |
| --- | --- |
| `ListRailsGuides` | Returns a lookup table of every official Rails guide, mapped title → URL |
| `FetchRailsGuide` | Downloads one guide, extracts the `<article>` content, returns it to the model |

`FetchRailsGuide` will only fetch URLs that appear in the `ListRailsGuides` table, so the model cannot be talked into fetching an arbitrary URL it hallucinated or that a user injected into the conversation.

The system prompt tells the assistant to decline non-Rails questions outright, to ask a clarifying question when a prompt is too vague, and to say "the guides don't cover this" rather than guess. Assistant replies come back as Markdown and are rendered through Redcarpet with `filter_html` and `safe_links_only`, then passed through an allowlist sanitizer — guide pages are untrusted input, so the output is treated as untrusted too.

## Features

- **Grounded answers** — every reply is based on a Rails guide the model fetched during the request
- **Persistent chat history** — chats are scoped to your account, revisit them any time
- **Google sign-in** — via Devise and OmniAuth, or plain email + password
- **Live-updating UI** — Turbo Streams append messages, a Stimulus controller shows a thinking spinner
- **10 messages per chat** — enforced at the model level to keep the context window (and the API bill) in check

## Tech stack

- Ruby 3.3.5, Rails 8.1
- PostgreSQL
- [ruby_llm](https://github.com/crmne/ruby_llm) against OpenAI (`gpt-4.1-mini`)
- Hotwire (Turbo + Stimulus), Bootstrap 5, Simple Form
- Devise + omniauth-google-oauth2
- Solid Queue / Solid Cache / Solid Cable

## Getting started

### Prerequisites

- Ruby 3.3.5
- PostgreSQL running locally
- An OpenAI API key
- Google OAuth credentials (only needed if you want the "Sign in with Google" button to work)

### Setup

```bash
git clone https://github.com/LMR271/guide-rails.git
cd guide-rails
bundle install
rails db:create db:migrate
```

Create a `.env` file in the project root (it's gitignored):

```bash
OPENAI_API_KEY=sk-...
GOOGLE_OAUTH_CLIENT_ID=...
GOOGLE_OAUTH_CLIENT_SECRET=...
```

Then start the server:

```bash
bin/dev
```

Visit http://localhost:3000, sign up, and start a chat.

### Running the tests

```bash
rails test
```

## Project layout

The parts worth knowing about:

```
app/controllers/messages_controller.rb   System prompt + the ruby_llm call
app/models/message.rb                    Roles (user / ai_assistant), 10-message limit
app/helpers/application_helper.rb        Markdown rendering + sanitization
lib/tools/list_rails_guides.rb           Guide title → URL lookup table
lib/tools/fetch_rails_guide.rb           Fetches and extracts one guide
```

## Data model

```
User ──< Chat ──< Message
```

A `User` has many chats, a `Chat` has a topic and many messages, and each `Message` has a `role` of either `user` or `ai_assistant`. Deleting a user cascades to their chats and messages.

## Contributors

Built by Lennart Reh, Erik Petrowski, and Hazel Ceballos as a Le Wagon bootcamp project.
