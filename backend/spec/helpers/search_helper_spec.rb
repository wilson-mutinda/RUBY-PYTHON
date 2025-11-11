require 'rails_helper'
RSpec.describe SearchHelper, type: :helper do
  describe "#search_category_name" do
    let (:categories) do
      [
        double(id: 1, category_name: 'aa'),
        double(id: 2, category_name: 'bb'),
        double(id: 3, category_name: 'cc'),
        double(id: 4, category_name: 'dd'),
      ]
    end
    it "returns an error if category name exists" do
      result = helper.search_category_name(categories, 'aa')
      expect(result).to eq({ errors: { name: "Category name exists!"}})
    end

    it "returns the exact name if not found" do
      result = helper.search_category_name(categories, 'ee')
      expect(result).to eq('ee')
    end
  end

  describe "#search_category_by_slug" do
    let(:categories) do
      [
        double(id: 1, category_name: 'aa', slug: 'ww'),
        double(id: 2, category_name: 'bb', slug: 'xx'),
        double(id: 3, category_name: 'cc', slug: 'yy'),
        double(id: 4, category_name: 'dd', slug: 'zz')
      ]
    end

    it 'returns an error if id is not found' do
      result = helper.search_category_by_slug(categories, 5)
      expect(result).to eq({ errors: { category: "Category with ID 5 not found!"}})
    end

    it "returns an object if id was found" do
      result = helper.search_category_by_slug(categories, 2)
      expect(result).to eq(categories[1])
    end

    it "returns an error if slug is not found" do
      result = helper.search_category_by_slug(categories, 'v')
      expect(result).to eq({ errors: { category: "Category with slug 'v' not found!"}})
    end

    it "returns an object if slug was found" do
      result = helper.search_category_by_slug(categories, 'zz')
      expect(result).to eq(categories[3])
    end

    it "returns an error if name is not found" do
      result = helper.search_category_by_slug(categories, 'ee')
      expect(result).to eq({ errors: { category: "Category with slug 'ee' not found!"}})
    end

    it "returns an object if name was found" do
      result = helper.search_category_by_slug(categories, 'dd')
      expect(result).to eq(categories[3])
    end
  end

  describe "#unique_category_name" do
    let(:categories) do
      [
        double(id: 1, category_name: 'aa'),
        double(id: 2, category_name: 'bb'),
        double(id: 3, category_name: 'cc'),
      ]
    end

    it "returns an error if category name alredy exists" do
      result = helper.unique_category_name(categories, 'cc', 6)
      expect(result).to eq({ errors: { category: "Category name already exists!"}})
    end

    it "returns name if not found" do
      result = helper.unique_category_name(categories, 'dd', 4)
      expect(result).to eq('dd')
    end

    it "returns name if id matches" do
      result = helper.unique_category_name(categories, 'bb', 2)
      expect(result).to eq('bb')
    end
  end

  describe "#search_post_by_slug" do
    let(:posts) do
      [
        double(id: 1, description: 'aa', slug: 'xx'),
        double(id: 2, description: 'bb', slug: 'yy'),
        double(id: 3, description: 'cc', slug: 'zz')
      ]
    end

    it "returns an error is ID is not found" do
      result = helper.search_post_by_slug(posts, 4)
      expect(result).to eq({ errors: { post: "Post not found for ID 4"}})
    end

    it "returns an object if id was found" do
      result = helper.search_post_by_slug(posts, 3)
      expect(result).to eq(posts[2])
    end

    it "returns an error if slug was not found" do
      result = helper.search_post_by_slug(posts, 'dd')
      expect(result).to eq({ errors: { post: "Post not found for slug dd"}})
    end

    it "returns object if slug was found" do
      result = helper.search_post_by_slug(posts, 'yy')
      expect(result).to eq(posts[1])
    end
  end

  describe "#search_user_email" do
    let(:users) do
      [
        double(id: 1, email: 'aa@gmail.com'),
        double(id: 2, email: 'bb@gmail.com'),
        double(id: 3, email: 'cc@gmail.com')
      ]
    end
    it "returns an error if email alredy exists" do
      result = helper.search_user_email(users, 'aa@gmail.com')
      expect(result).to eq({ errors: { email: "Email already exists!"}})
    end

    it "returns email if does not exist" do
      result = helper.search_user_email(users, 'dd@gmail.com')
      expect(result).to eq('dd@gmail.com')
    end
  end

  describe "#search_user_phone" do
    let(:users) do
      [
        double(id: 2, phone: '254717221287'),
        double(id: 3, phone: '254748929891'),
        double(id: 1, phone: '254791738418'),
      ]
    end

    it "returns an error if phone exists" do
      result = helper.search_user_phone(users, '254791738418')
      expect(result).to eq({ errors: { phone: "Phone already exists!"}})
    end

    it "returns phone if not found" do
      result = helper.search_user_phone(users, '254790909090')
      expect(result).to eq('254790909090')
    end
  end

  describe "#search_user_by_slug" do
    let(:users) do
      [
        double(id: 1, email: 'aa@gmail.com', phone: '254717221287', slug: 'xx'),
        double(id: 2, email: 'bb@gmail.com', phone: '254723050525', slug: 'yy'),
        double(id: 3, email: 'cc@gmail.com', phone: '254791738418', slug: 'zz'),
      ]
    end

    it "returns an error if user does not exist" do
      result = helper.search_user_by_slug(users, 4)
      expect(result).to eq({ errors: { user: "User with ID 4 not found!"}})
    end

    it "returns an object if id was found" do
      result = helper.search_user_by_slug(users, 1)
      expect(result).to eq(users[0])
    end

    it "returns an error if email does not exist" do
      result = helper.search_user_by_slug(users, 'ab@gmail.com')
      expect(result).to eq({ errors: { user: "User with slug ab@gmail.com not found!"}})
    end

    it "returns an object if email was found" do
      result = helper.search_user_by_slug(users, 'aa@gmail.com')
      expect(result).to eq(users[0])
    end
  end

  describe "#unique_email_search" do
    let(:users) do
      [
        double(id: 1, email: 'aa@gmail.com'),
        double(id: 2, email: 'bb@gmail.com'),
      ]
    end

    it 'returns an error if email exists' do
      result = helper.unique_email_search(users, 'aa@gmail.com', 3)
      expect(result).to eq({ errors: { email: "Email has been taken!"}})
    end

    it "returns an object if email does not exist" do
      result = helper.unique_email_search(users, 'ab@gmail.com', 3)
      expect(result).to eq('ab@gmail.com')
    end

    it "returns the same email for the same user" do
      result = helper.unique_email_search(users, 'aa@gmail.com', 1)
      expect(result).to eq('aa@gmail.com')
    end
  end
end
