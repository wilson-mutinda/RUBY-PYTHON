module SearchHelper
  def search_category_name(categories, target_name)
    target_name = target_name.to_s.downcase
    first_index = 0;
    last_index = categories.length - 1;

    while first_index <= last_index
      mid_index = (first_index + last_index) / 2;
      mid_category = categories[mid_index]

      if mid_category.category_name.downcase == target_name
        return { errors: { name: "Category name exists!"}}
      elsif mid_category.category_name.downcase < target_name
        first_index = mid_index + 1;
      else
        last_index = mid_index - 1;
      end
    end
    target_name
  end

  def search_category_by_slug(categories, slug)
    slug = slug.to_s.downcase

    # check by ID
    if slug.match?(/\d/) && slug.length <= 4
      # find by ID
      slug = slug.to_i
      first_index = 0;
      last_index = categories.length - 1;

      while first_index <= last_index
        mid_index = (first_index + last_index) / 2;
        mid_category = categories[mid_index]

        if mid_category.id == slug
          return mid_category
        elsif mid_category.id < slug
          first_index = mid_index + 1;
        else
          last_index = mid_index - 1;
        end
      end
      return { errors: { category: "Category with ID #{slug} not found!"}}
    end

    # else find by slug
    categories.each do |category|
      if category.present? && (category.slug.downcase == slug || category.category_name.downcase == slug)
        return category
      end
    end

    { errors: { category: "Category with slug '#{slug}' not found!"}}
  end

  def unique_category_name(categories, target_name, current_id)
    target_name = target_name.to_s.downcase
    first_index = 0;
    last_index = categories.length - 1;

    while first_index <= last_index
      mid_index = (first_index + last_index) / 2;
      mid_category = categories[mid_index]

      if mid_category.category_name.downcase == target_name
        if mid_category.id != current_id
          return { errors: { category: "Category name already exists!"}}
        end
        return mid_category.category_name.downcase
      elsif mid_category.category_name.downcase < target_name
        first_index = mid_index + 1;
      else
        last_index = mid_index - 1;
      end
    end
    target_name
  end

  def search_post_by_slug(posts, slug)
    slug = slug.to_s.downcase
    # check if slug is an ID
    if slug.match?(/\d/) && slug.length <= 4
      slug = slug.to_i

      first_index = 0;
      last_index = posts.length - 1;

      while first_index <= last_index
        mid_index = (first_index + last_index) / 2;
        mid_post = posts[mid_index]

        if mid_post.id == slug
          return mid_post
        elsif mid_post.id < slug
          first_index = mid_index + 1;
        else
          last_index = mid_index - 1;
        end
      end
      return { errors: { post: "Post not found for ID #{slug}"}}
    end

    # Oterwise search by slug or description
    post = posts.find { |p| p.slug.downcase == slug ||
           posts.find { |p| p.description.downcase == slug }}

    return post || { errors: { post: "Post not found for slug #{slug}"}}
    
  end

  def search_user_email(users, target_email)
    target_email = target_email.to_s.gsub(/\s+/, '').downcase
    first_index = 0;
    last_index = users.length - 1;

    while first_index <= last_index
      mid_index = (first_index + last_index) / 2;
      mid_user = users[mid_index]

      if mid_user.email.downcase == target_email
        return { errors: { email: "Email already exists!"}}
      elsif mid_user.email.downcase < target_email
        first_index = mid_index + 1;
      else
        last_index = mid_index - 1;
      end
    end
    target_email
  end

  def search_user_phone(users, target_phone)
    target_phone = target_phone.to_s.gsub(/\s+/, '')
    first_index = 0;
    last_index = users.length - 1;
    
    while first_index <= last_index
      mid_index = (first_index + last_index) / 2;
      mid_user = users[mid_index]

      if mid_user.phone == target_phone
        return { errors: { phone: "Phone already exists!"}}
      elsif mid_user.phone < target_phone
        first_index = mid_index + 1;
      else
        last_index = mid_index - 1;
      end
    end
    target_phone
  end

  def search_user_by_slug(users, slug)
    slug = slug.to_s.gsub(/\s+/, '').downcase

    # check if slug was an ID
    if slug.match?(/\d/) && slug.length <= 4
      # search by id
      slug = slug.to_i

      first_index = 0;
      last_index = users.length - 1;

      while first_index <= last_index
        mid_index = (first_index + last_index) / 2;
        mid_user = users[mid_index]

        if mid_user.id == slug
          return mid_user
        elsif mid_user.id < slug
          first_index = mid_index + 1;
        else
          last_index = mid_index - 1;
        end
      end
      return { errors: { user: "User with ID #{slug} not found!"}}
    end

    # otherwise find by email or slug
    user = users.find { |u| (u.email.downcase.gsub(/\s+/, '') == slug || u.slug.downcase == slug || u.phone == slug) }
    return user || { errors: { user: "User with slug #{slug} not found!"}} 
  end

  def unique_email_search(users, target_email, current_id)
    target_email = target_email.to_s.gsub(/\s+/, '').downcase
    first_index = 0;
    last_index = users.length - 1;

    while first_index <= last_index
      mid_index = (first_index + last_index) / 2;
      mid_user = users[mid_index]

      if mid_user.email == target_email
        unless mid_user.id == current_id
          return { errors: { email: "Email has been taken!"}}
        end
        return mid_user.email
      elsif mid_user.email < target_email
        first_index = mid_index + 1;
      else
        last_index = mid_index - 1;
      end
    end
    target_email
  end

  def unique_phone_search(users, target_phone, current_id)
    target_phone = target_phone.to_s.gsub(/\s+/, '')
    first_index = 0;
    last_index = users.length - 1;

    while first_index <= last_index
      mid_index = (first_index + last_index) / 2;
      mid_user = users[mid_index]

      if mid_user.phone == target_phone
        unless mid_user.id == current_id
          return { errors: { phone: "Phone has been taken!"}}
        end
        return mid_user.phone
      elsif mid_user.phone < target_phone
        first_index = mid_index + 1;
      else
        last_index = mid_index - 1;
      end

    end
    target_phone
  end

end