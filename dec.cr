require "uuid"
require "kemal"

r = Random.new

init_xvfb_process = Process.new("./start_xvfb.sh")
raise "dec.sh failed" if !init_xvfb_process.wait.success?

get "/:text" do |env|
  id = UUID.new(r.random_bytes)
  text = env.params.url["text"]
  out_path = "./out/#{id}.wav"

  begin
    process = Process.new("./dec.sh", [id.to_s, text], output: Process::Redirect::Pipe)
    puts process.output.gets_to_end

    raise "dec.sh failed" if !process.wait.success?

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
