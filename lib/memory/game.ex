defmodule Memory.Game do

  def new do
    gen_game()
  end

  def toggle(game, id) do
    key = Integer.to_string(id)
    cond do
      0 <= id and MapSet.size(game[:selected_ids]) < 2 and !MapSet.member?(game[:selected_ids], key) and !game[:tiles][key][:is_solved] and id < Enum.count(game[:tiles]) ->
        selected_ids = MapSet.put(game[:selected_ids], key)
        last_interaction = if MapSet.size(game[:selected_ids]) === 0, do: :os.system_time(:milli_seconds), else: Map.get(game, :last_interaction, 0)
	Map.merge(game, %{selected_ids: selected_ids, clicks: game[:clicks] + 1, last_interaction: last_interaction})
      true ->
       game
    end
  end

  def check(game) do
    selected_ids = game[:selected_ids] |> MapSet.to_list
    cond do
      800 < :os.system_time(:milli_seconds) - Map.get(game, :last_interaction, 0) ->
        Map.merge(game, %{selected_ids: MapSet.new})
      2 <= MapSet.size(game[:selected_ids]) and game[:tiles][Enum.at(selected_ids, 0)][:value] === game[:tiles][Enum.at(selected_ids, 1)][:value] ->
        tiles = Enum.reduce(0..1, game[:tiles], fn(i, acc) ->
          key = Enum.at(selected_ids, i)
          Map.put(acc, key, Map.merge(game[:tiles][key], %{is_solved: true}))
        end)
        Map.merge(game, %{tiles: tiles, selected_ids: MapSet.new})
      true ->
        game
    end
  end

  def client_view(game) do
    %{
      tiles: Enum.reduce(15..0, [], fn(i, acc) ->
        key = Integer.to_string(i)
        v = game[:tiles][key]
        value = if v[:is_solved] or MapSet.member?(game[:selected_ids], key), do: List.to_string([v[:value]]), else: ""
        [%{isSolved: v[:is_solved], value: value} | acc]
      end),
      clicks: game[:clicks],
      selectedIds: MapSet.size(game[:selected_ids]) > 0
    }
  end 


  def gen_unique_letter(acc) do
    num = Enum.random(65..73)
    cond do
      !MapSet.member?(acc, num) ->
        num
      true ->
        gen_unique_letter(acc)
    end
  end

  def gen_game do
    letter_codes = Enum.reduce 0..7, MapSet.new, fn(i, acc) ->
      MapSet.put(acc, gen_unique_letter(acc))
    end

    letters = MapSet.to_list(letter_codes)

    tiles = Enum.concat(letters, letters) |> Enum.shuffle |> Enum.reduce(%{}, fn(v, acc) ->
        Map.put(acc, Integer.to_string(Enum.count(acc)), %{is_solved: false, value: v})
    end)

    %{
      tiles: tiles,
      selected_ids: MapSet.new,
      clicks: 0
    }
  end


end
