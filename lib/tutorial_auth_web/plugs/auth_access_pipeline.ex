defmodule TutorialAuthWeb.AuthAccessPipeline do
  use Guardian.Plug.Pipeline, otp_app: :tutorial_auth

  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource, allow_blank: true
end
