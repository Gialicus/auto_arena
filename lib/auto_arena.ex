defmodule AutoArena do
  alias AutoArena.Character
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{winners: [], p1: "", p2: ""}, name: __MODULE__)
  end

  def init(state) do
    state = %{
      state
      | p1: :gialicus,
        p2: :batman
    }

    run(state, 2)
  end

  def run(state, level) do
    IO.puts("#{IO.ANSI.yellow()}Fight #{level} n° Start!#{IO.ANSI.reset()}\n")
    {:ok, player1} = Character.start_link(state.p1, level)
    {:ok, player2} = Character.start_link(state.p2, level)
    GenServer.cast(player1, {:start_fight, player2})
    GenServer.cast(player2, {:start_fight, player1})
    {:ok, state}
  end
end
