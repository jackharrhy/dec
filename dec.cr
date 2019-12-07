require "uuid"
require "kemal"

r = Random.new

get "/:text" do |env|
  id = UUID.new(r.random_bytes)
  text = env.params.url["text"]
  out_path = "./out/#{id}.wav"

  begin
    process = Process.new("./dec.sh", [id.to_s, text], output: Process::Redirect::Pipe)
    puts process.output.gets_to_end

    if !process.wait.success?
      raise "dec.sh failed"
    end

    send_file env, out_path
  rescue ex
    puts "request failed: #{ex.message}"
  end

  if File.exists? out_path
    File.open out_path do |file|
      file.delete
    end
  end
end

Kemal.run
