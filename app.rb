require 'sinatra'
require 'slim'
require_relative './model.rb'

enable :sessions



get('/') do
    if session["id"]
        recept = favorites(session["id"])
        p recept
        slim(:home, locals:{recept:recept})
    else
        redirect("/login")
    end
end

get('/bank') do
    db = SQLite3::Database.new("db/db.db")
    db.results_as_hash = true
    result = db.execute("SELECT count(favorites.fav_id) as likes, id,name,picture,description,cg_name,cg_id FROM receptbank JOIN categories ON receptbank.type=categories.cg_id JOIN favorites ON receptbank.id=favorites.recept_id WHERE receptbank.id NOT IN (SELECT recept_id FROM favorites WHERE user_id = ?) GROUP BY recept_id", session["id"])
    p result
    slim(:bank, locals:{recept:result})
end

post('/recept/add') do
    recept_id = params["id"]
    like_recept(recept_id, session["id"])
    redirect("/bank")
end

post('/recept/delete') do
    fav_id = params["id"]
    unlike_recept(fav_id, session["id"])
    redirect("/")
end

post('/user/register') do
    username = params["username"]
    password = params["password"]
    password_repeat = params["password_repeat"]
    if password == password_repeat
        register_user(username, password)
        redirect("/login")
    else 
        redirect("/error")
    end
end

get('/register') do
    slim(:"loginreg/register")
    
end

post('/user/login') do
    username = params["username"]
    password = params["password"]
    user_id = login_user(username, password)
    if user_id != false
        session[:id] = user_id
        redirect("/")
    else 
        redirect("/error")
    end
end

get('/login') do
    slim(:"loginreg/login")
    
end
#post('/users/') do
    #username = params["username"]
    #password = params["password"]
    #user_register(username, password)
    #redirect('/photos')
#end
   

#post('/upload_image') do
    #Skapa en sträng med join "./public/uploaded_pictures/cat.png"
    #path = File.join("./public/uploaded_pictures/",params[:file][:filename])
    
    #Skriv innehållet i tempfile till path
    #File.write(path,File.read(params[:file][:tempfile]))
    
    #redirect('/upload_image')
#end
   