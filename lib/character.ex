defmodule AutoArena.Character do
  alias AutoArena.Skill
  use GenServer

  def start_link(name, level \\ 1) do
    skills = for _ <- 1..level, do: Skill.new(IO.ANSI.cyan())

    GenServer.start_link(
      __MODULE__,
      %{
        name: name,
        hp: 200 * level,
        skills: skills
      },
      name: name
    )
  end

  def init(state) do
    {:ok, state}
  end

  def handle_cast({:start_fight, opponent_pid}, state) do
    for skill <- state.skills do
      GenServer.cast(opponent_pid, {:hit, skill})
    end

    {:noreply, state}
  end

  def handle_cast({:hit, skill}, state) do
    :timer.sleep(1000 * skill.cooldown)

    {lower_bound, upper_bound} = skill.damage
    damage = Enum.random(lower_bound..upper_bound)

    hp = state.hp - damage

    IO.puts(fmt_attack(skill.name, state.name, damage, hp, skill.cooldown))

    if hp <= 0 do
      IO.puts("#{IO.ANSI.magenta()}#{state.name}#{IO.ANSI.reset()} has been defeated!")
      {:stop, :normal, state}
    else
      GenServer.cast(self(), {:hit, skill})
      {:noreply, %{state | hp: hp}}
    end
  end

  defp fmt_attack(skill_name, player_name, damage, hp, cd) do
    player_name = "#{IO.ANSI.magenta()}#{IO.ANSI.bright()}#{player_name}#{IO.ANSI.reset()}"
    damage = "#{IO.ANSI.red()}#{damage}#{IO.ANSI.reset()}"
    hp = "#{IO.ANSI.green()}#{hp}#{IO.ANSI.reset()}"
    cd = "#{IO.ANSI.yellow()}#{cd}#{IO.ANSI.reset()}"
    "#{skill_name} hit #{player_name} for #{damage} damage! HP: #{hp} next in #{cd}s"
  end
end
