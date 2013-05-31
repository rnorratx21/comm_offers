module PervasiveReporting
  # module InstanceMethods
  def pervasive_tag_scans(dates={:start_date => 1000.days.ago, :end_date => Date.today})
    if self.pervasive_page_id
      result = pervasive_client.ws_call "TagScanAnalytics", {
        :pageId => self.pervasive_page_id, :startDate => dates[:start_date], :endDate => dates[:end_date]
      }
      result.tagScanAnalyticsResult
    end
  end

  def pervasive_redemptions(dates={:start_date => 1000.days.ago, :end_date => Date.today})
    if self.mobile_id
      result = pervasive_client.ws_call "CouponRedemptionAnalytics", {
        :couponId => self.mobile_id, :startDate => dates[:start_date], :endDate => dates[:end_date]
      }
      result.couponRedemptionAnalyticsResult
    end
  end

  def pervasive_app_views(dates={:start_date => 1000.days.ago, :end_date => Date.today})
    if self.mobile_id
      result = pervasive_client.ws_call "CouponAppViewAnalytics", {
        :couponId => self.mobile_id, :startDate => 1000.days.ago, :endDate => Date.today
      }
      result.couponAppViewAnalyticsResult
    end
  end


  private

  def reporting_client
    @client ||= PervasiveClient.new
  end

  # end
end
