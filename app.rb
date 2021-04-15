require 'sinatra'
require 'slim'
require_relative './model.rb'

enable :sessions



get('/') do
    recept = favorites(1)
    p recept
    slim(:home, locals:{recept:recept})
    
end

get('/bank') do
    db = SQLite3::Database.new("db/db.db")
    db.results_as_hash = true
    result = db.execute("SELECT id,name,picture,description,cg_name,cg_id FROM receptbank JOIN categories ON receptbank.type=categories.cg_id WHERE receptbank.id NOT IN (SELECT recept_id FROM favorites WHERE user_id = 1)")
    p result
    slim(:bank, locals:{recept:result})
end

post('/recept/add') do
    recept_id = params["id"]
    like_recept(recept_id, 1)
    redirect("/bank")
end

post('/recept/delete') do
    fav_id = params["id"]
    unlike_recept(fav_id, 1)
    redirect("/")
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
   