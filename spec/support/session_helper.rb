# frozen_string_literal: true

module SessionHelper
  def login(env, user_id)
    env['rack.session'] = { user_id: user_id }
  end
end
