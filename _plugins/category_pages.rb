module Jekyll
  class CategoryPageGenerator < Generator
    safe true
    priority :lowest

    def generate(site)
      puts "[CategoryPageGenerator] Starting category page generation..."
      
      # 레이아웃 체크
      if !site.layouts.key? 'category'
        puts "[CategoryPageGenerator] ERROR: 'category' layout not found!"
        puts "[CategoryPageGenerator] Available layouts: #{site.layouts.keys.join(', ')}"
        return
      end
      
      puts "[CategoryPageGenerator] Found 'category' layout, proceeding..."
      
      # 모든 포스트에서 카테고리 수집
      categories = []
      site.posts.docs.each do |post|
        post_categories = post.data['categories']
        if post_categories.is_a?(String)
          categories << post_categories
        elsif post_categories.is_a?(Array)
          categories.concat(post_categories)
        end
      end
      categories = categories.uniq.sort
      
      puts "[CategoryPageGenerator] Found categories: #{categories.join(', ')}"
      
      # 각 카테고리별로 페이지 생성
      categories.each do |category|
        next if category.empty?
        
        # 해당 카테고리의 포스트만 필터링
        category_posts = site.posts.docs.select do |post|
          post_categories = post.data['categories']
          if post_categories.is_a?(String)
            post_categories == category
          elsif post_categories.is_a?(Array)
            post_categories.include?(category)
          else
            false
          end
        end
        
        # 카테고리 페이지 생성
        page = CategoryPage.new(site, site.source, category, category_posts)
        site.pages << page
        puts "[CategoryPageGenerator] Created page for '#{category}' with #{category_posts.size} posts at /categories/#{category}/"
      end
      
      puts "[CategoryPageGenerator] Generation completed!"
    end
  end

  class CategoryPage < Page
    def initialize(site, base, category, posts)
      @site = site
      @base = base
      @dir = File.join('categories', category)
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'category.html')
      
      self.data['category'] = category
      self.data['posts'] = posts.sort_by(&:date).reverse
      self.data['title'] = "#{category.capitalize} 카테고리"
      self.data['permalink'] = "/categories/#{category}/"
    end
  end
end