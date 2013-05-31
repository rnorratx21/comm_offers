require 'fastercsv'
module Admin::SalesReportingHelper
  def generate_report_csv
    FasterCSV.generate do |csv|
      @sales_report.as_arrays.each do |arr|
        csv << arr
      end
    end
  end

  def salesperson_filters
    filter_dropdown User.salespeople.collect{|u| [u.display_name, u.id.to_s]}
  end

  def sales_area_filters
    filter_dropdown SalesArea.by_name.collect{|sa| [sa.name, sa.id.to_s]}
  end

  def status_filters
    options_for_select Invoice::STATUSES.collect{|s| [s.titleize, s]}, @sales_report.statuses
  end

  def filter_dropdown(opts)
    [%w(All all)].concat opts
  end
  
  def sales_report_total
    @sales_report.invoices.map(&:total_amount).inject{|sum,i|sum+i}.to_f
  end
  
end