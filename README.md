# thorsten-michael.de

This repository contains the source code for my personal website, https://thorsten-michael.de. It is based on the amazing [Phoenix](https://phoenixframework.org) web framework which is build on Elixir/Erlang. See the section about [technical decisions](#technical-decisions) for more detail about this.

## Motivation

Why do you have a personal web page at all, you may ask? And what's your reasoning behind making the repository public?

> Das erste Haus baust du für deinen Feind, das zweite für deinen Freund und das dritte für dich selbst

This german saying, sometimes attributed to the famous philosopher Confucius, which translates roughly into:

> You will build the first house for your foe, the second for your friend and the third one for yourself

So far, I haven't build any houses, but several websites and applications during the last decades. Some of them were part of my professional work, others for friends. Some applications were toy projects for myself to get a feeling for a programming language, an emerging framework or technology. Others supported me to get some stuff done. You know, these kind of projects you expect to save you tons of work in the future, but you spend many hours until they are ready.

But until now, I never build my personal web page. And for good reason: I didn't know what story to tell. The web hosts _n_ dull websites nobody cares about (and _n_ is a sufficiently large number), so there's no point wasting time contributing _n+1_. That would not change the world for the better. On the other hand, there are so many professional portfolios out there promoting themselves that I cannot and do not want to compete with them. So I've been putting off creating a personal website until I have something substantial to share that I deeply care about, that is helpful to others, and honest about myself.

This point in time has come now, and these are the reasons:

- I would like to continue sending e-mails to my friends with the mail address @t-online.de from my own mail server with the address @thorsten-michael.de.[¹]
  [^1]: Although this sounds like a joke about net neutrality: The mail servers at t-online reject legitimate e-mails from a mail server on a domain that doesn't have a website with a proper imprint. For that, I'm forced to reveal my private address, which puts data privacy upside down. Of course, I don't want to display an otherwise blank website just to have an imprint. Fun fact: Even DENIC, which registers all top level ".de" domains, conceals my personal data from the public for privacy reasons.
- I need to apply for new jobs. This is by far the deeper reason why I have to reach out and show off some expertise and qualities.

So, I decided to create my personal website that is going to be _the house for myself_ and telling the story about building it along the way. Therefore, this _repository is open to the public_ to show off not only what is built, but how and the reasoning behind it. This is quite a challenge, but also an advantage for myself:

- I have to be mindful and take time in the construction process, rather than just getting something up and running.
- I have to be careful about sensitive data. The application obviously has to be designed to store secrets outside the source code. This can be accomplished by storing all application configuration in the environment, as suggested in [The twelve-factor App](https://12factor.net/config).

Does this website change the world for the better? Probably not. Is it helpful to others? Maybe, I hope so. But for sure, this is about something substantial that I deeply care about.

## Goals

TBD

## Technical decisions

TBD

# Using the Code yourself

Though there might not be great benefit in cloning this repo and just using it as-it-is, you can do so:

To start your Phoenix server:

- Install dependencies with `mix deps.get`
- Create and migrate your database with `mix ecto.setup`
- Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

- Official website: https://www.phoenixframework.org/
- Guides: https://hexdocs.pm/phoenix/overview.html
- Docs: https://hexdocs.pm/phoenix
- Forum: https://elixirforum.com/c/phoenix-forum
- Source: https://github.com/phoenixframework/phoenix
