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
end
