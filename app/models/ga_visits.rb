require 'garb'
class GaVisits
  extend Garb::Model
  def initialize
    @profile = GaProfile.new.profile
  end

  metrics :pageviews

  def ga_results(opts)
    self.class.results(@profile, opts)
  end

  def all_time_offer_visits_count(offer, permalink_path)
    opts = {}
    opts[:start_date] = $system_start_date
    opts[:end_date] = Date.today
    count = 0

    result_old_url = ga_results(opts.merge(:filters => {:page_path.eql => "/offers/#{offer.id}"})).to_a
    # puts "old url: #{result_old_url.inspect}"
    count += result_old_url.first.pageviews.to_i if result_old_url.any?

    result_new_url = ga_results(opts.merge(:filters => {:page_path.eql => permalink_path})).to_a
    # puts "new url: #{result_new_url.inspect}"
    count += result_new_url.first.pageviews.to_i if result_new_url.any?

    count
  end
end