require 'sinatra'
require 'slim'
require_relative './model.rb'
require 'pp'

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

    result = db.execute("SELECT count(favorites.fav_id) as likes,id,name,picture,description,cg_name,cg_id FROM receptbank 
    outer left JOIN categories ON receptbank.type=categories.cg_id 
    outer left JOIN favorites ON receptbank.id=favorites.recept_id 
    GROUP BY receptbank.id")

    slim(:bank, locals:{recept:result})
end

post('/recept/like') do
    recept_id = params["id"]
    like_recept(recept_id, session["id"])
    redirect("/bank")
end

post('/recept/unlike') do
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
    slim(:"user/register")
    
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
    slim(:"user/login")
end

get('/admin') do
    if session[:id] != nil
        if is_admin(session[:id]) 
            p "hej"
            recept = fetch_recepies()
            p recept
            slim(:admin, locals:{recept:recept})
        else
            redirect("/error/Inga_Privilegier")
        end
    else
        p "Not logged in! "
        redirect("/error/Inte_inloggad")
    end
end

post('/recept/add') do
    namn = params["namn"]
    bild = params["bild"]
    beskrivning = params["beskrivning"]
    kategori = params["kategori"]
    if session[:id] != nil
        if is_admin(session[:id]) 
            addrecept(namn, bild, beskrivning, kategori)
        end
    end
    redirect("/bank")
end

post('/recept/update') do
    namn = params["name"]
    description = params["description"]
    type = params["type"]
    id = params["id"]
    if session[:id] != nil
        if is_admin(session[:id])
            p namn, description, type, id
            if update(namn, description, type, id) 
                redirect("/admin")
            else
                redirect("/error/Kunde_inte_ändra_recept")
            end
        else
            redirect("/error/Inga_Privilegier")
        end
    else
        redirect("/error/Inte_inloggad")
    end

end

get("/error/:message") do
    message = params[:message]

    slim(:error, locals:{message:message})
end


post('/recept/delete') do
    id = params["id"]
    if session[:id] != nil
        if is_admin(session[:id])
            if delete(id) 
                redirect("/admin")
            else
                redirect("/error/Kunde_inte_ta_bort_recept")
            end
        else
            redirect("/error/Inga_Privilegier")
        end
    else
        redirect("/error/Inte_inloggad")
    end
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
   