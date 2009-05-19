class MephistoImport
 
  @@errors = Hash.new

  class << self
    attr_accessor :errors
    attr_accessor :users
    attr_accessor :pages   
  end
  
  
  self.errors = {}

  #Import the contents of a Mephisto db into radaint
  #
  #Usage:
  #   MephistoImport.all
  #
  #Notes: 
  #Lots of room here to break this up into smaller chunks of work / methods.
  def self.all
    users = []
    pages = []
    MephistoUser.id_mappings = {}
    for u in MephistoUser.find(:all)
       unless user = User.find_by_login(u.login)
         user = u.to_user
         user.save
       end  
       MephistoUser.id_mappings[u.id] = user.id # map old id to new id
       
       users << user.id
    end
    
    @published = MephistoArticle.find_all_published
    @parent    = Page.find_by_title('Blog')
    for article in @published
      page = article.to_page
      for c in article.comments
        comment = c.to_comment
        page.comments << comment
      end
      page.parent = @parent
      if page.save
        pages << page.id
        tags = [article.section_names].join(',').gsub(/\s+/,'').split(',').collect{|i| i.downcase.gsub(/[^a-zA-Z0-9]/, '')}.uniq.compact.reject{|i| i == 'home'}.join(' ')
        puts tags
        page.meta_tags = tags
      else
        puts page.errors.full_messages
        puts page.parts[0].filter
        puts page.parts[0].errors.full_messages
        @@errors[page] = page.errors 
      end
    end
  

  end

end
