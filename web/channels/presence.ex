defmodule BlackSwan.Presence do
  use Phoenix.Presence, otp_app: :blackswan,
                        pubsub_server: BlackSwan.PubSub
end