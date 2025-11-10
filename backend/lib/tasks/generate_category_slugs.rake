namespace :category do
  desc "Background task to generate the missing category slugs"
  task generate_category_slugs: :environment do
    puts "Started generating category slugs for missing"

    missing = Category.where(slug: [nil, ''])
    puts "Found #{missing.count} categories missing slugs"

    missing.find_each do |category|
      begin
        category.save!
        puts "Generated slug for '#{category.category_name}' -> #{category.slug}"
      rescue => e
        puts "Failed for '#{category.category_name}': #{e.message}"
      end
      
    end
    puts "Finished generating category slugs!"
  end
end