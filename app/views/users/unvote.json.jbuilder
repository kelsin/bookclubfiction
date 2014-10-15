json.user do
  json.partial! 'partials/user', :user => @user
end if @user
