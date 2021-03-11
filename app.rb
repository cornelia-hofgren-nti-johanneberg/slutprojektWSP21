require 'sinatra'
require 'slim'
require_relative './model.rb'

enable :sessions



get('/') do
    slim(:home)
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
   