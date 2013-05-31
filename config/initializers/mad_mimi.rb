mad_mimi = YAML.load_file("#{RAILS_ROOT}/config/mad_mimi.yml")

MadMimiMailer.api_settings = {
  :username => mad_mimi["username"],
  :api_key => mad_mimi["api_key"]
}
