class API < Grape::API
  format :json
  prefix :api

  resource "users" do
	desc "returns all users"
	get do
	  User.all
	end
  end

  resource "microposts" do
	desc "result all microposts"
	get do
	  Micropost.all
	end
  end

  resource "relationships" do
	desc "result all relationships"
	get do
	  Relationship.all
	end
  end
end

