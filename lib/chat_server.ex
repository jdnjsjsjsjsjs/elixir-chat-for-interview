# lib/chat_server.ex
defmodule ChatServer do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def join(name) do
    GenServer.cast(__MODULE__, {:join, self(), name})
  end

  def send_message(msg) do
    GenServer.cast(__MODULE__, {:message, self(), msg})
  end

  # callbacks

  @impl true
  def init(_) do
    {:ok, []}
  end

  @impl true
  def handle_cast({:join, pid, name}, users) do
    Process.monitor(pid)

    user = %Chat.User{pid: pid, name: name}

    IO.puts("#{name} joined the chat")

    {:noreply, [user | users]}
  end

  @impl true
  def handle_cast({:private_message, sender_pid, to_name, msg}, users) do
    sender = Enum.find(users, fn %{pid: pid} -> pid == sender_pid end)

    case sender do
      %Chat.User{name: from_name} ->
        case Enum.find(users, fn %{name: name} -> name == to_name end) do
          %Chat.User{pid: to_pid} ->
            send(to_pid, {:message, "[PM from #{from_name}]", msg})

          nil ->
            IO.puts("User #{to_name} not found")
        end

      nil ->
        IO.puts("Unknown sender")
    end

    {:noreply, users}
  end

  @impl true
  def handle_info({:DOWN, _ref, :process, pid, _reason}, users) do
    users = Enum.reject(users, fn %Chat.User{pid: p} -> p == pid end)

    IO.puts("User disconnected: #{inspect(pid)}")

    {:noreply, users}
  end

  def list_users do
    GenServer.call(__MODULE__, :list_users)
  end

  @impl true
  def handle_call(:list_users, _from, users) do
    {:reply, users, users}
  end

  def send_private(to_name, msg) do
    GenServer.cast(__MODULE__, {:private_message, self(), to_name, msg})
  end
end
