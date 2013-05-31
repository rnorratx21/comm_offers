config = YAML.load_file("#{RAILS_ROOT}/config/cheddar_getter.yml")[RAILS_ENV]

Mousetrap.authenticate config["username"], config["password"]
Mousetrap.product_code = config["product_code"]
