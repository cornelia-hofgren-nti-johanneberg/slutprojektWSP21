require 'sqlite3'
require 'bcrypt'


def connect()
    db = SQLite3::Database.new("db/db.db")
    db.results_as_hash = true
    return db
end

def add_recept()
    recept = connect().execute("INSERT INTO")
