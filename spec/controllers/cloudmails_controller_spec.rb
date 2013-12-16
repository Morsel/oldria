require_relative '../spec_helper'
FakeWeb.allow_net_connect = true
describe CloudmailsController do

  before(:each) do
    controller.stubs(:verify_cloudmail_signature).returns(true)

    @user = FactoryGirl.create(:user, :email => "reply-person@tester.com")
    User.stubs(:find).with('1').returns(@user)
    User.stubs(:find).with(@user.id, {:select => nil, :include => nil, :readonly => nil, :conditions => nil}).returns(@user)
  end

  context "Successful emails" do

    before(:each) do
      @user.expects(:validate_cloudmail_token!).returns(true)
    end

    it "should parse a valid QOTD response" do
      conversation = FactoryGirl.create(:admin_conversation, :recipient => @user, :admin_message => FactoryGirl.create(:qotd))
      Admin::Conversation.stubs(:find).returns(conversation)

      post :create, :to => "1-token-QOTD-1@dev-mailbot.restaurantintelligenceagency.com",
      :message => "",
      :plain => "This is my QOTD reply\nRespond by replying to this email - above this line\nThis is the QOTD message",
      :signature => ""

      conversation.comments.count.should == 1
      conversation.comments.first.user.should == @user
    end

    it "should parse a valid BTL response" do
      question = FactoryGirl.create(:profile_question)
      ProfileQuestion.stubs(:find).returns(question)

      post :create, :to => "1-token-BTL-1@dev-mailbot.restaurantintelligenceagency.com",
                    :message => "",
                    :plain => "This is my BTL reply\nRespond by replying to this email - above this line\nThis is the BTL message",
                    :signature => ""

      question.profile_answers.count.should == 1
      question.profile_answers.first.user.should == @user
    end

    it "should parse a valid Trend Question response from a restaurant employee" do
      restaurant = FactoryGirl.create(:restaurant, :manager => @user)
      FactoryGirl.create(:employment, :restaurant => restaurant)
      discussion = FactoryGirl.create(:admin_discussion,
                           :restaurant => restaurant,
                           :discussionable => FactoryGirl.create(:trend_question, :subject => "Trend to reply to"))
      AdminDiscussion.stubs(:find).returns(discussion)

      post :create, :to => "1-token-RD-1@dev-mailbot.restaurantintelligenceagency.com",
                    :message => "",
                    :plain => "This is my Trend Q reply\nRespond by replying to this email - above this line\nThis is the Trend message",
                    :signature => ""

      discussion.comments.count.should == 1
      discussion.comments.first.user.should == @user
    end

    it "should parse a valid Trend Question response from a solo employee" do
      employment = FactoryGirl.create(:default_employment, :employee => @user)
      discussion = FactoryGirl.create(:solo_discussion,
                           :employment => employment,
                           :trend_question => FactoryGirl.create(:trend_question, :subject => "Another trend to reply to"))
      SoloDiscussion.stubs(:find).returns(discussion)

      post :create, :to => "1-token-SD-1@dev-mailbot.restaurantintelligenceagency.com",
                    :message => "",
                    :plain => "This is my Trend Q reply\nRespond by replying to this email - above this line\nThis is the Trend message",
                    :signature => ""

      discussion.comments.count.should == 1
      discussion.comments.first.user.should == @user
    end

    it "should produce a clean reply from an iPhone user's response" do
      message = read_sample('iphone.txt')

      conversation = FactoryGirl.create(:admin_conversation, :recipient => @user, :admin_message => FactoryGirl.create(:qotd))
      Admin::Conversation.stubs(:find).returns(conversation)

      post :create, :to => "1-token-QOTD-1@dev-mailbot.restaurantintelligenceagency.com",
           :message => "",
           :html => "",
           :plain => message,
           :signature => ""

      conversation.comments.first.comment.should == "Morimoto. Hands down. No one else can hold a candle to him."
    end

    it "should produce a clean reply from a Blackberry user's response" do
      message = read_sample('blackberry.txt')

      conversation = FactoryGirl.create(:admin_conversation, :recipient => @user, :admin_message => FactoryGirl.create(:qotd))
      Admin::Conversation.stubs(:find).returns(conversation)

      post :create, :to => "1-token-QOTD-1@dev-mailbot.restaurantintelligenceagency.com",
           :message => "",
           :html => "",
           :plain => message,
           :signature => ""

      conversation.comments.first.comment.should == "Good quality pans....all clad."
    end

    it "should produce a clean reply from a Blackberry/T-Mobile user's response" do
      message = read_sample('blackberry_tmo.txt')

      conversation = FactoryGirl.create(:admin_conversation, :recipient => @user, :admin_message => FactoryGirl.create(:qotd))
      Admin::Conversation.stubs(:find).returns(conversation)

      post :create, :to => "1-token-QOTD-1@dev-mailbot.restaurantintelligenceagency.com",
           :message => "",
           :html => "",
           :plain => message,
           :signature => ""

      conversation.comments.first.comment.should == "The philosophy behind it is to serve good food that makes everybody feel good about eating. We have a small staff of between 6-8 any night and it's a family environment. We all like to eat well, so we do. I also want the servers to be geared up to run the floor and talk to people with energy and enthusiasm. It can get pretty tiring to talk to 40-85 people a night with energy. We serve a lot of grains and pastas so people have a satisfied feeling. A good amount of chicken as well. We like to get homey with the staff meal too especially in the winter so everyone can kinda feel like they are at home. Meatloaf, chicken and dumplings, meatballs, roasted chicken, macaroni and cheese, etc. My special treat when I make staff is fried rice!"
    end

    it "should produce a clean reply from a Gmail user's response" do
      message = read_sample('gmail.txt')
      message.gsub!(/(?:\r|\n)*$/, "\r\n") # re-creating Gmail's line endings

      conversation = FactoryGirl.create(:admin_conversation, :recipient => @user, :admin_message => FactoryGirl.create(:qotd))
      Admin::Conversation.stubs(:find).returns(conversation)

      post :create, :to => "1-token-QOTD-1@dev-mailbot.restaurantintelligenceagency.com",
           :message => "",
           :plain => message,
           :html => "",
           :signature => ""

      conversation.comments.first.comment.should == "we make squash blossom quesadillas. they are traditional mexican snacks, and
go well with the green mole salsa we do using the squash seeds."
    end

    it "should produce a clean reply from a Yahoo user's response" do
      message = read_sample('yahoo.txt')

      conversation = FactoryGirl.create(:admin_conversation, :recipient => @user, :admin_message => FactoryGirl.create(:qotd))
      Admin::Conversation.stubs(:find).returns(conversation)

      post :create, :to => "1-token-QOTD-1@dev-mailbot.restaurantintelligenceagency.com",
           :message => "",
           :plain => message,
           :html => "",
           :signature => ""

      conversation.comments.first.comment.should == "John is using young peas in a new course involving lardo, vanilla, and wild pea flowers, all enriched with creamy egg."
    end

    it "should produce a clean reply from a Yahoo classic user's response" do
      message = read_sample('yahoo_classic.txt')

      conversation = FactoryGirl.create(:admin_conversation, :recipient => @user, :admin_message => FactoryGirl.create(:qotd))
      Admin::Conversation.stubs(:find).returns(conversation)

      post :create, :to => "1-token-QOTD-1@dev-mailbot.restaurantintelligenceagency.com",
           :message => "",
           :html => "",
           :plain => message,
           :signature => ""

      conversation.comments.first.comment.should == "I am a true American...HOT DOGS! I love the Smoky Links at Comiskey. They have better food than Wrigley. But...I am a Cubs fan!"
    end

    it "should produce a clean reply from a Hotmail user's response" do
      message = read_sample('hotmail.txt')

      conversation = FactoryGirl.create(:admin_conversation, :recipient => @user, :admin_message => FactoryGirl.create(:qotd))
      Admin::Conversation.stubs(:find).returns(conversation)

      post :create, :to => "1-token-QOTD-1@dev-mailbot.restaurantintelligenceagency.com",
           :message => "",
           :html => "",
           :plain => message,
           :signature => ""

      conversation.comments.first.comment.should == "I'm going to fight every urge to rant here and simply state:  being southern born and raised, this is embarrassing to the music and food industry. I'm sure they'll make millions."
    end

    it "should produce a clean reply from a Microsoft Office Outlook 12.0 user's response" do
      message = read_sample('outlook.txt')

      conversation = FactoryGirl.create(:admin_conversation, :recipient => @user, :admin_message => FactoryGirl.create(:qotd))
      Admin::Conversation.stubs(:find).returns(conversation)

      post :create, :to => "1-token-QOTD-1@dev-mailbot.restaurantintelligenceagency.com",
      :message => "",
      :plain => message,
      :signature => ""

      conversation.comments.first.comment.should == "My Mom was a fearless and adventuresome cook but it was my Dad who got me into the kitchen. When I  was 8 Dad started a subscription to Gourmet magazine. Most of the recipes were a little strange for 1964 in Indianapolis Indiana but Dad and I loved reading the travel articles and we would pore over the recipes wondering where we would find the exotic ingredients. Dad and I made Caesar salad together at least once a month. I would toss while he squeezed the lemon and showed me how to perfectly coddle an egg. Dad manned the grill in the summer but that was about it as far as cooking went. It was his enthusiasm and unabashed enjoyment of eating that was his specialty. He showed me the connection between cooking and love-something I hold very dear.\nChef Susan Goss\nWest Town Tavern\n1329 W Chicago Avenue\nChicago, IL 60642\n312-666-6175\nVisit our newly designed website at:\nhttp://www.westtowntavern.com\ndinner monday-saturday 5-10pm\nVisit out facebook page at:\nhttp://www.facebook.com/#!/WestTownTavern\nFollow Chef Susan's Blog at\nhttp:chefsusangoss.wordpress.com\nwtt-logo-sig"
    end

    it "should produce a clean reply from Katherine at Branch's response" do
      message = read_sample("branch.txt")

      conversation = FactoryGirl.create(:admin_conversation, :recipient => @user, :admin_message => FactoryGirl.create(:qotd))
      Admin::Conversation.stubs(:find).returns(conversation)

      post :create, :to => "1-token-QOTD-1@dev-mailbot.restaurantintelligenceagency.com",
           :message => "",
           :plain => message,
           :signature => ""

      conversation.comments.first.comment.should == "we have been using them in both salads and risotto. People love the delicate
taste"
    end

    it "should produce a clean reply from Prairie Grass Cafe" do
      message = read_sample("prairiegrasscafe.txt")

      conversation = FactoryGirl.create(:admin_conversation, :recipient => @user, :admin_message => FactoryGirl.create(:qotd))
      Admin::Conversation.stubs(:find).returns(conversation)

      post :create, :to => "1-token-QOTD-1@dev-mailbot.restaurantintelligenceagency.com",
           :message => "",
           :plain => message,
           :signature => ""

      conversation.comments.first.comment.should == "I would eat at Vij's.I ate there before and really loved the service and food."
    end

    it "should produce a clean reply from plaintext that's really html" do
      message = read_sample("html_bug.txt")

      conversation = FactoryGirl.create(:admin_conversation, :recipient => @user, :admin_message => FactoryGirl.create(:qotd))
      Admin::Conversation.stubs(:find).returns(conversation)

      post :create, :to => "1-token-QOTD-1@dev-mailbot.restaurantintelligenceagency.com",
           :message => "",
           :plain => message,
           :signature => ""

      conversation.comments.first.comment.should == "Teaspoon.My brother wanted it to be Half Pint but I didn't like that.So now it's teaspoon."    
    end

    it "should produce a clean reply from a myTouch user's response" do
      message = read_sample("mytouch.txt")

      conversation = FactoryGirl.create(:admin_conversation, :recipient => @user, :admin_message => FactoryGirl.create(:qotd))
      Admin::Conversation.stubs(:find).returns(conversation)

      post :create, :to => "1-token-QOTD-1@dev-mailbot.restaurantintelligenceagency.com",
           :message => "",
           :plain => message,
           :signature => ""

      conversation.comments.first.comment.should == "I made a peach torrentes sorbet as a sweet finish."
    end

    it "should produce a clean reply from an email with a known signature" do
      message = read_sample('outlook.txt')

      conversation = FactoryGirl.create(:admin_conversation, :recipient => @user, :admin_message => FactoryGirl.create(:qotd))
      Admin::Conversation.stubs(:find).returns(conversation)

      for line in "Chef Susan Goss\nWest Town Tavern\n1329 W Chicago Avenue\nChicago, IL 60642\n312-666-6175\nVisit our newly designed website at:\nhttp://www.westtowntavern.com\ndinner monday-saturday 5-10pm\nVisit out facebook page at:\nhttp://www.facebook.com/#!/WestTownTavern\nFollow Chef Susan's Blog at\nhttp:chefsusangoss.wordpress.com\nwtt-logo-sig".split("\n") do
        Admin::EmailStopword.create!(:phrase => line)
      end

      post :create, :to => "1-token-QOTD-1@dev-mailbot.restaurantintelligenceagency.com",
           :message => "",
           :html => "",
           :plain => message,
           :signature => ""

      conversation.comments.first.comment.should == "My Mom was a fearless and adventuresome cook but it was my Dad who got me into the kitchen. When I  was 8 Dad started a subscription to Gourmet magazine. Most of the recipes were a little strange for 1964 in Indianapolis Indiana but Dad and I loved reading the travel articles and we would pore over the recipes wondering where we would find the exotic ingredients. Dad and I made Caesar salad together at least once a month. I would toss while he squeezed the lemon and showed me how to perfectly coddle an egg. Dad manned the grill in the summer but that was about it as far as cooking went. It was his enthusiasm and unabashed enjoyment of eating that was his specialty. He showed me the connection between cooking and love-something I hold very dear."
    end

    it "should produce a clean reply from Jonathon's Ruhlman answer" do
      message = read_sample('jonathon-ruhlman.txt')
      message.gsub!(/(?:\r|\n)*$/, "\r\n") # re-creating Gmail's line endings

      conversation = FactoryGirl.create(:admin_conversation, :recipient => @user, :admin_message => FactoryGirl.create(:qotd))
      Admin::Conversation.stubs(:find).returns(conversation)

      post :create, :to => "1-token-QOTD-1@dev-mailbot.restaurantintelligenceagency.com",
           :message => "",
           :html => "",
           :plain => message,
           :signature => ""

      conversation.comments.first.comment.should == "My favorite cooking book by Ruhlman is Ratio. The app is so useful, I use\nit almost every day in my home life and restaurants.  I'm also a big fan of\nHouse: A memoir. It's full of great stories and really makes me appreciate\nliving in a century home. I'd have to say that he has had a tremendous\ninfluence on my career in the best possible way.\nMy favorite cooking book by Ruhlman is Ratio. The app is so useful, I use\nit almost every day in my home life and restaurants.  I'm also a big fan of\nHouse: A memoir. It's full of great stories and really makes me appreciate\nliving in a century home. I'd have to say that he has had a tremendous\ninfluence on my career in the best possible way.\nOn Apr 4, 2012, at 11:56 AM,"
    end

    it "should produce a clean reply from Ellen's Gmail test answer" do
      message = read_sample('new_gmail.txt')
      message.gsub!(/(?:\r|\n)*$/, "\r\n") # re-creating Gmail's line endings

      conversation = FactoryGirl.create(:admin_conversation, :recipient => @user, :admin_message => FactoryGirl.create(:qotd))
      Admin::Conversation.stubs(:find).returns(conversation)

      # Current production stopwords that may be interferring with reading the message
      for phrase in ["M. Page", "Thanks,", "RG", "Check out my web site:", "www.rickgresh.com", "www.cigarbque.com", "Typos courtesy of IPhone.", "I'm better with sharp knives and hot pans!", "HEIDI HAGEMAN", "@h2pr", "[http://spoonfeed.restaurantintelligenceagency.com/images/emails/top_bg.gif?et_id=1vzhjp4]", "[http://spoonfeed.restaurantintelligenceagency.com/images/emails/left_bg.gif?et_id=1vzhl5w]"] do
        Admin::EmailStopword.create!(:phrase => phrase)
      end

      post :create, :to => "1-token-QOTD-1@dev-mailbot.restaurantintelligenceagency.com",
           :message => "",
           :html => "",
           :plain => message,
           :signature => ""

      conversation.comments.first.comment.should == "testing"
    end

  end

  it "should send an error to a user who tries to reply to an already-answered Trend Question for their main restaurant" do
    restaurant = FactoryGirl.create(:restaurant, :manager => @user)
    discussion = FactoryGirl.create(:admin_discussion,
                         :restaurant => restaurant,
                         :discussionable => FactoryGirl.create(:trend_question, :subject => "Trend to reply to more than once"))
    AdminDiscussion.stubs(:find).returns(discussion)
    comment = Comment.create!(:commentable => discussion, :user => restaurant.media_contact, :title => "A previous comment")
    discussion.comments.count.should == 1

    post :create, :to => "1-token-RD-1@dev-mailbot.restaurantintelligenceagency.com",
                  :message => "",
                  :plain => "This is my Trend Q reply\nRespond by replying to this email - above this line\nThis is the Trend message",
                  :signature => ""

    discussion.comments.count.should == 1
  end

  it "should send an error to a user who removes the reply separator text" do
    conversation = FactoryGirl.create(:admin_conversation, :recipient => @user, :admin_message => FactoryGirl.create(:qotd))
    Admin::Conversation.stubs(:find).returns(conversation)

    post :create, :to => "1-token-QOTD-1@dev-mailbot.restaurantintelligenceagency.com",
                  :message => "",
                  :plain => "This is my QOTD reply - I deleted everything else",
                  :signature => ""

    conversation.comments.count.should == 0
  end

  describe "on the menu" do

    before(:each) do
      @restaurant = FactoryGirl.create(:restaurant, :manager => @user)
      Restaurant.stubs(:find).returns(@restaurant)
    end

    it "should create a new menu item from an incoming email" do
      post :create, :to => "otm-#{@restaurant.id}@dev-mailbot.restaurantintelligenceagency.com",
                    :plain => "A new dish you should try.\n\n$13",
                    :message => "",
                    :subject => "The name of the dish",
                    :signature => "",
                    :attachments => { '0' => { 'file_name' => 'test.jpg', 'content_type' => 'image/jpg', 'url' => 'http://spoonfeed.s3.amazonaws.com/test/cloudmailin/otm_photo.jpg' } }

      MenuItem.count.should == 1
      menu_item = MenuItem.first
      menu_item.price.should == "13"
      menu_item.name.should == "The name of the dish"
      menu_item.description.should == "A new dish you should try."
    end

    it "should process a photo attachment on the menu item email" do
      # FakeWeb.allow_net_connect = 'http://spoonfeed.s3.amazonaws.com/test/cloudmailin/otm_photo.jpg'

      post :create, :to => "otm-#{@restaurant.id}@dev-mailbot.restaurantintelligenceagency.com",
                    :plain => "A new dish you should try, complete with photo!\n\n$13",
                    :message => "",
                    :subject => "The name of the dish",
                    :signature => "",
                    :attachments => { '0' => { 'file_name' => 'test.jpg', 'content_type' => 'image/jpg', 'url' => 'http://spoonfeed.s3.amazonaws.com/test/cloudmailin/otm_photo.jpg' } }

      MenuItem.count.should == 1
      menu_item = MenuItem.first
      menu_item.photo_file_name.should_not be_nil
    end

    it "should send an error report if the menu item can't be created" do
      MenuItem.any_instance.stubs(:save!).raises(ActiveRecord::RecordInvalid.new(MenuItem.new))

      post :create, :to => "otm-#{@restaurant.id}@dev-mailbot.restaurantintelligenceagency.com",
                    :plain => "Not a real description",
                    :message => "",
                    :subject => "Blank subject",
                    :signature => ""

      MenuItem.count.should == 0
    end

  end

end
