FactoryGirl.define do
  
  factory :device_line do
    name 'iPhone'
  end
  
  factory :device do
    name 'iPhone 4'
  end
  
  factory :supported_device_code do
    code 'iPhone4'
  end
  
  factory :app do
    name 'TypeLink'
    api_key 12345
    version '1.0.9'
    price 0.00
    category 'Productivity'
    icon_url 'http://a3.mzstatic.com/us/r1000/087/Purple/64/11/7c/mzi.vbrpetdo.png'
    itunes_link 'http://itunes.apple.com/us/app/typelink/id412347169?mt=8&uo=4'
    itunes_rating 4
  end
  
end
