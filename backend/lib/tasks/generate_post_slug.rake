namespace :post do
  desc "Create slugs fir missing ones"
  task generate_post_slugs: :environment do
    puts "Started generating empty slugs"
    
    missing = Post.where(slug: [nil, ''])
    puts "Found #{missing.length} posts missing slugs"

    missing.each do |post|
      post.save!
      puts "Generated slugs for post #{post}: #{post.slug}"
    end

    puts "Done generating slugs!"
  end
end