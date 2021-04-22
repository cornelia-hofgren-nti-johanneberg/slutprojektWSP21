require 'sqlite3'
require 'bcrypt'


def connect()
    db = SQLite3::Database.new("db/db.db")
    db.results_as_hash = true
    return db
end

def like_recept(recept_id, user_id)
    recept = connect().execute("INSERT INTO favorites (recept_id, user_id) VALUES (?,?)", recept_id, user_id)
end

def unlike_recept(fav_id, user_id)
    respons = connect().execute("SELECT * FROM favorites WHERE fav_id = ? AND user_id = ?", fav_id, user_id)
    if respons[0]
        connect().execute("DELETE FROM favorites WHERE fav_id = ?", fav_id)
    end
end



def favorites(user_id)
    recept = connect().execute("SELECT * FROM favorites JOIN receptbank ON favorites.recept_id = receptbank.id JOIN categories ON receptbank.type=categories.cg_id WHERE favorites.user_id = ?", user_id)
    return recept
end


def register_user(username, password)
    password_digest = BCrypt::Password.create(password)
    connect().execute("INSERT INTO users (username,password) VALUES (?,?)", username, password_digest)
end

def login_user(username, password)
    result = connect().execute("SELECT * FROM users WHERE username = ?", username)
    p result[0]
    p result[0]["password"]
    if result[0] && BCrypt::Password.new(result[0]["password"]) == password
        return result[0]["id"].to_i
    end
    return false
end