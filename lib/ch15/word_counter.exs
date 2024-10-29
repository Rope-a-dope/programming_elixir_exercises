defmodule WordCounter do
  def start_link(scheduler) do
    send(scheduler, {:ready, self()})
    loop()
  end

  defp loop do
    receive do
      {:work, file, scheduler} ->
        content = File.read!(file)
        count = count_word(content, "cat")
        send(scheduler, {:answer, file, count, self()})
        loop()

      :shutdown ->
        exit(:normal)
    end
  end

  defp count_word(content, word) do
    Regex.scan(~r/\b#{Regex.escape(word)}\b/i, content)
    |> length()
  end
end

defmodule Scheduler do
  def run(num_processes, module, func, to_calculate) do
    (1..num_processes)
    |> Enum.map(fn _ -> spawn(module, func, [self()]) end)
    |> schedule_processes(to_calculate, [])
  end

  defp schedule_processes(processes, queue, results) do
    receive do
      {:ready, pid} when queue != [] ->
        [next | tail] = queue
        send(pid, {:work, next, self()})
        schedule_processes(processes, tail, results)

      {:ready, pid} ->
        send(pid, :shutdown)
        if length(processes) > 1 do
          schedule_processes(List.delete(processes, pid), queue, results)
        else
          Enum.sort(results, fn {file1, _}, {file2, _} -> file1 <= file2 end)
        end

      {:answer, file, result, _pid} ->
        schedule_processes(processes, queue, [{file, result} | results])
    end
  end
end

# Running the Scheduler to count "cat" in each file in the directory
defmodule CatCounter do
  def run(directory) do
    files = File.ls!(directory)
    Scheduler.run(length(files), WordCounter, :start_link, files)
  end
end

results = CatCounter.run("path/to/your/directory")
IO.inspect(results)
