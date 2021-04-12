# frozen_string_literal: true

module NoAuth
  def User.create(**params)
    user = User.new(params)
    user.skip_confirmation!
    user.save
    user
  end

  def User.create!(**params)
    user = User.new(params)
    user.skip_confirmation!
    user.save!
    user
  end
end
