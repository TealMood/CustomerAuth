require 'sinatra'

# Run this behind ngrok proxy to test SSL redirect
get "/:app/auth/callback" do
    puts request.query_string
    redirect_url = "#{params["app"]}://auth/callback?#{request.query_string}"
    redirect redirect_url
end
