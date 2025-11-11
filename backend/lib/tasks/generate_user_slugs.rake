namespace :user do
  desc "Generating user slugs for missing ones"
  task generate_user_slugs: :environment do
    puts "Generating slugs for missing ones"
    missing = User.where(slug: [nil, ''])
    puts "Found #{missing.length} users missing slugs"

    missing.find_each do |user|
      user.slug = user.email.parameterize

      puts "Generated slugs: #{user.slug}"

      # update the user with their slugs
      user.update(slug: user.slug)

      puts "Generated slugs for each user"
    end
  end
end