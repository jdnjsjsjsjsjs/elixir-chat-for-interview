# lib/realtime_chat/application.ex
defmodule RealtimeChat.Application do
  use Application

  def start(_type, _args) do
    children = [
      ChatServer
    ]

    opts = [strategy: :one_for_one, name: RealtimeChat.Supervisor]

    Supervisor.start_link(children, opts)
  end
end
