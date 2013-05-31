Factory.define :category_type do |ct|
  ct.name "Cat type"
end

Factory.define :category do |c|
  c.name "Foo Cat"
  c.association :category_type
end

Factory.define :offer do |o|
  o.association :advertiser
  o.headline 'Headline'
  o.title 'title'
  o.description 'description'
  o.hours '9-5'
  o.effective 'immediately'
  o.payment_methods 'right arm'
  o.association :category 
  o.expires_on 1.month.from_now
end

Factory.define :contract_plan do |c|
  c.name 'Super-Premium-Platinum-Hiend-Expensivo'
  c.system_key 'superdooper'
  c.setup_amount '50'
  c.installment_amount '100'
  c.period 'month'
  c.installments '12'
  c.due_on_day '1'
end

Factory.define :advertiser do |a|
  a.name 'Foo'
end

Factory.define :credit_card do |c|
  c.number '1'
  c.first_name 'Test'
  c.last_name 'Example'
  c.display_number 'XXX1'
  c.month '01'
  c.expires_on Date.today+1.year
  c.zip_code '99999'
  c.verification_value '111'
  c.address1 '123 Sesame Street'
end