require "uuid"
require "kemal"

r = Random.new

get "/:text" do |env|
  id = UUID.new(r.random_bytes())
  text = env.params.url["text"]
  out_path = "./out/#{id}.wav"

  begin
    process = Process.new("./dec.sh", [id.to_s, text], output: Process::Redirect::Pipe)
    raise "dec.sh failed" if !process.wait.success?

    send_file env, out_path
  rescue ex
    puts "request failed: #{ex.message}"
  end

  File.open(out_path) do |file|
    file.delete
  end
end

Kemal.run
