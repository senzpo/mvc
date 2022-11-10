# frozen_string_literal: true

# Main gateway for persisted storage
class ApplicationRepository
  def self.db_config
    YAML.load_file('config/database.yml')[Application::Config.env]
  end

  DB = Sequel.connect(db_config['db']['connection_line'])
end
