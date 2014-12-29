atom_feed do |feed|
  feed.title("User's microposts")
  feed.updated((@microposts.first.created_at))

  @microposts.each do |micropost|
	feed.entry(micropost, url: "http://example.com/atoms/#{micropost.id}") do |entry|
		entry.user(micropost.user)
		entry.content(micropost.content, type: 'html')
	end
  end
end
