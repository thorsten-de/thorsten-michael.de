[
  import_deps: [:ecto, :phoenix, :live_view],
  inputs: ["*.{ex,exs,heex}", "priv/*/seeds.exs", "{config,lib,test}/**/*.{ex,exs,heex}"],
  subdirectories: ["priv/*/migrations"],
  plugins: [Phoenix.LiveView.HTMLFormatter]
]
