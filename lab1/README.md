# Lab1
-----
# Topic: *Streaming Twitter sentiment analysis system*
### Author: *Serghei Derevenco*
-----
## Implemented features
1. Reading 2 SSE streams of actual Twitter API tweets in JSON format using the following project: https://github.com/cwc/eventsource_ex;  
2. Creating the following entitties: Worker, Router, Connection, WorkerSupervisor;  
3. WorkerSupervisor was implemented as DynamicSupervisor;  
4. Also was implemented feature for getting text of every tweet.
5. Solved bug with SSE connection restarting.  
5. Link to screencast: https://youtu.be/PRkw0sKxn7c  
-----
## To use
* Make a pull request to a remote Docker container: `docker pull alexburlacu/rtp-server:faf18x`.
* Then run it: `docker run -p 4000:4000 --rm alexburlacu/rtp-server:faf18x`.
* Configure the project dependencies: `mix deps.get`.
* Compile the project: `iex -S mix`.
## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `lab1` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:lab1, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/lab1](https://hexdocs.pm/lab1).

