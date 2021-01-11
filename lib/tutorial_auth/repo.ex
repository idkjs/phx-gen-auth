defmodule TutorialAuth.Repo do
  use Ecto.Repo,
    otp_app: :tutorial_auth,
    adapter: Ecto.Adapters.Postgres
end
