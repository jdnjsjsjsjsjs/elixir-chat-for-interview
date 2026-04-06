# lib/chat_client.ex
defmodule ChatClient do
  def start(name) do
    pid = spawn(fn -> init(name) end)
    pid
  end

  defp init(name) do
    ChatServer.join(name)
    listen(name)
  end

  defp listen(name) do
    receive do
      {:send_message, msg} ->
        ChatServer.send_message(msg)
        listen(name)

      {:send_private, to_name, msg} ->
        ChatServer.send_private(to_name, msg)
        listen(name)

      {:message, from, msg} ->
        IO.puts("[#{from}]: #{msg}")
        listen(name)
    end
  end

  def send_message(pid, msg) do
    send(pid, {:send_message, msg})
  end

  def start_cli(name) do
    pid = ChatClient.start(name)
    spawn(fn -> cli_loop(pid) end)
  end

  defp cli_loop(pid) do
    msg = IO.gets("> ") |> String.trim()
    ChatClient.send_message(pid, msg)
    cli_loop(pid)
  end

  def send_private(pid, to_name, msg) do
    send(pid, {:send_private, to_name, msg})
  end
end
