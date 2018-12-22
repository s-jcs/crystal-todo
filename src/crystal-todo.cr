require "./crystal-todo/*"

require "kemal"
require "leveldb"

db = LevelDB::DB.new("./db")

get "/" do
  render "./src/views/home.ecr", "./src/views/layouts/base.ecr"
end

post "/" do |env|
  value = env.params.body["todo"]
  iterator = LevelDB::Iterator.new(db)
  iterator.seek_to_first

  unless iterator.valid?
    db.put("0000000", value)
  else
    iterator.seek_to_last
    key = iterator.key

    n_key = (key.to_i + 1).to_s
    zeros = ""

    (7 - n_key.size).times do
      zeros += "0"
    end
    n_key = zeros + n_key
    db.put(n_key, value)
  end

  iterator.destroy
  render "./src/views/home.ecr", "./src/views/layouts/base.ecr"
end

delete "/" do |env|

  render "./src/views/home.ecr", "./src/views/layouts/base.ecr"
end

Kemal.run
