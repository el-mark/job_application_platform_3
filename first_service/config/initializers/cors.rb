Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins "http://localhost:3002" # Adjust this to your React app's URL
      resource "*",
        headers: :any,
        methods: [ :get, :post, :put, :patch, :delete, :options, :head ],
        expose: [ "access-token", "expiry", "token-type", "uid", "client" ],
        max_age: 600
    end
end
