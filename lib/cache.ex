defmodule Cache do
  use GenServer
  @moduledoc """
  Cache for infos.
  """

  # Client
  def start_link(args \\ []) do
    GenServer.start_link(__MODULE__, :ok, args ++ [name: __MODULE__])
  end

  def write(key, value) when is_atom(key) do
    GenServer.cast(__MODULE__, {:write, key, value})
  end

  def write(_, _) do
    :error
  end

  def read(key) when is_atom(key) do
    GenServer.call(__MODULE__, {:read, key})
  end

  def read(_) do
    :error
  end

  def delete(key) do
    GenServer.cast(__MODULE__, {:delete, key})
  end

  def get_all do
    GenServer.call(__MODULE__, :get_all)
  end

  def clear do
    GenServer.cast(__MODULE__, :clear)
  end

  def exists?(key) do
    GenServer.call(__MODULE__, {:if_exists, key})
  end

  # Server
  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call({:read, key}, _from, state) do
    {:reply, state[key], state}
  end

  def handle_call(:get_all, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:if_exists, key}, _from, state) do
    {:reply, Map.has_key?(state, key), state}
  end

  def handle_cast({:write, key, value}, state) do
    new_state = Map.put_new(state, key, value)
    {:noreply, new_state}
  end

  def handle_cast({:delete, key}, state) do
    new_state = Map.delete(state, key)
    {:noreply, new_state}
  end

  def handle_cast(:clear, _state) do
    {:noreply, %{}}
  end

  # Helpers
end
