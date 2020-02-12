if Rails.env.production?
  NEW_RELIC_LICENSE_KEY = "a7fdb1b249adfc406de2f2ee4ff855838d4147a8"
  NEW_RELIC_APP_NAME = "CleanJay Production"
end

#if Rails.env.production? == false
#  p "Non-production env ================================================================================"
#end
