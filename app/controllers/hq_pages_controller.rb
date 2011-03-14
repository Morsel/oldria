class HqPagesController < Hq::HqController
  layout 'hq'
  
  def show
    @page = HqPage.find(params[:id])
    @feed = Feedzirra::Feed.fetch_and_parse('http://feeds.feedburner.com/RIAUnplugged')
    @feed.entries.sort! {|x,y| y.published <=> x.published }
  end
  
end
