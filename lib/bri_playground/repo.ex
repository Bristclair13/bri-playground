defmodule BriPlayground.Repo do
  use Ecto.Repo,
    otp_app: :bri_playground,
    adapter: Ecto.Adapters.Postgres
end
