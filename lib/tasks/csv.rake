namespace :csv do
  desc "Creates a csv file with contract info."
  task :create => :environment do
    offers = Offer.all
    File.open('contracts.csv', 'w') do |writer|
      row = []
      offers.each do |o|
        if o.contract
          row << o.contract_id.to_s
          row << o.advertiser.name + "/" + o.title
          if o.contract.invoices[0]
            row << o.contract.invoices[0].due_date
            row << o.contract.invoices[0].total_amount
            if o.contract.invoices[1]
              row << o.contract.invoices[1].due_date
            else
              row << "N/A"
            end
          else
            row << "N/A" 
            row << "N/A"
            row << "N/A"
          end
          row << o.contract.credit_card.nil? ? "No" : "Yes"
          row.each do |r|
            writer << r.to_s + ','
          end
          writer << '\n'
        end
      end
      writer.close
    end
  end  
end
