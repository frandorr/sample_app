FactoryGirl.define do
  factory :user do
    name     "Fran"
    email    "fran@pepe.com"
    password "foobar"
    password_confirmation "foobar"
  end
end