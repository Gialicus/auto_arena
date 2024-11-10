defmodule AutoArena.Skill do
  defstruct name: nil, damage: 0, cooldown: 0

  @prefix_names [
    "Fire",
    "Ice",
    "Lightning",
    "Earth",
    "Wind",
    "Water",
    "Dark",
    "Light",
    "Poison"
  ]

  @base_names [
    "Hit",
    "Strike",
    "Blast",
    "Wave",
    "Beam",
    "Bolt",
    "Slash",
    "Punch",
    "Kick",
    "Shot",
    "Arrow",
    "Bite",
    "Claw"
  ]

  @suffix_names [
    "of Doom",
    "of Death",
    "of Destruction",
    "of Annihilation",
    "of Obliteration",
    "of Ruin",
    "of Despair",
    "of Suffering",
    "of Pain",
    "of Agony",
    "of Torment",
    "of Misery"
  ]

  def new(color) do
    cooldown = Enum.random(3..5)

    damage =
      case cooldown do
        3 -> {10, 25}
        4 -> {25, 75}
        5 -> {75, 100}
      end

    %AutoArena.Skill{
      name: "#{color}#{gen_name()}#{IO.ANSI.reset()}",
      damage: damage,
      cooldown: cooldown
    }
  end

  defp gen_name do
    prefix = Enum.random(@prefix_names)
    base = Enum.random(@base_names)
    suffix = Enum.random(@suffix_names)
    "#{prefix} #{base} #{suffix}"
  end
end
