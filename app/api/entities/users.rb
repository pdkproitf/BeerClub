module Entities
  class Users < Grape::Entity
    format_with(:iso_timestamp) { |dt| dt.iso8601 }

    expose :name, documentation: { type: String, value: 'Ryan Pham' }
    expose  :email, documentation: { type: String, value: 'ryanpham@gmail.com'}
    expose  :password, documentation: { type: String, value: 'ryanpham'}
    expose  :password_confirmation, documentation: { type: String, value: 'ryanpham'}

    with_options(format_with: :ios_timestamp) do
      expose :created_at
      expose :updated_at
    end
  end
end
